import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'settings.dart';

class SRKRPage extends StatefulWidget {
  const SRKRPage({Key? key}) : super(key: key);

  @override
  State<SRKRPage> createState() => _SRKRPageState();
}

class _SRKRPageState extends State<SRKRPage> {
  final scrollController = ScrollController();
  int selectedCategoryIndex = 0;
  double skrkInfoHeight = 150 //appbar expandedHeight
      +
      0 //restaruant info height
      -
      kToolbarHeight;

  @override
  void initState() {
    createBreackPoints();
    scrollController.addListener(() {
      //print(scrollController.offset);
      updateCategoryIndexOnScroll(scrollController.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(int index) {
    if (selectedCategoryIndex != index) {
      int totalItems = 0;
      for (var i = 0; i < index; i++) {
        totalItems += demoCategoryMenus[i].items.length;
      }
      scrollController.animateTo(skrkInfoHeight + (50 * totalItems) + (85 * index), duration: const Duration(milliseconds: 600), curve: Curves.ease);
      setState(() {
        selectedCategoryIndex = index;
      });
    }
  }

  List<double> breackPoints = [];

  void createBreackPoints() {
    double firstBreackPoint = skrkInfoHeight + 85 + (50 * demoCategoryMenus[0].items.length);
    breackPoints.add(firstBreackPoint);
    for (var i = 1; i < demoCategoryMenus.length; i++) {
      double breackPoint = breackPoints.last + 85 + (50 * demoCategoryMenus[i].items.length);
      breackPoints.add(breackPoint);
    }
  }

  void updateCategoryIndexOnScroll(double offset) {
    for (var i = 0; i < demoCategoryMenus.length; i++) {
      if (i == 0) {
        if ((offset < breackPoints.first) & (selectedCategoryIndex != 0)) {
          setState(() {
            selectedCategoryIndex == 0;
          });
        }
      } else if ((breackPoints[i - 1] <= offset) & (offset < breackPoints[i])) {
        if (selectedCategoryIndex != i) {
          setState(() {
            selectedCategoryIndex = i;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(2, 14, 28, 1),
          Color.fromRGBO(75, 94, 117, 1),
          Color.fromRGBO(46, 69, 97, 1),
          Color.fromRGBO(2, 14, 28, 1),
          Color.fromRGBO(21, 44, 71, 1),
          Color.fromRGBO(46, 69, 97, 1),
          Color.fromRGBO(2, 14, 28, 1),
          Color.fromRGBO(75, 94, 117, 1),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 160,
                backgroundColor: const Color.fromRGBO(163, 225, 230, 0.01),
                elevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.arrow_back,
                        size: 35,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: InkWell(
                            child: Image.asset(
                              "assets/logo.png",
                              height: 100,
                              width: 300,
                            ),
                            onTap: () {
                              _launchUrl("http://srkrec.edu.in/");
                            },
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.facebook,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 7),
                                          child: Text(
                                            "FB",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => _launchUrl("https://www.facebook.com/SRKRECOFFICIAL"),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Instagram",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => _launchUrl("https://www.instagram.com/srkr_engineering_college/"),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Twitter",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => _launchUrl("https://twitter.com/SRKR_EC"),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black,
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "YouTube",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () => _launchUrl("https://www.youtube.com/c/SRKREC"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                )),
              ),
              const SliverToBoxAdapter(
                child: RestaurantInfo(),
              ),
              SliverPersistentHeader(
                delegate: RestaurantCategories(
                  onChanged: scrollToCategory,
                  selectedIndex: selectedCategoryIndex,
                ),
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, categoryIndex) {
                    List<Menu> items = demoCategoryMenus[categoryIndex].items;
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: MenuCategoryItem(
                        title: demoCategoryMenus[categoryIndex].category,
                        items: List.generate(
                            items.length,
                            (index) => MenuCard(
                                  title: items[index].title,
                                  url: items[index].url,
                                )),
                      ),
                    );
                  },
                  childCount: demoCategoryMenus.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Menu {
  final String title, url;

  Menu({required this.title, required this.url});
}

class CategoryMenu {
  final String category;
  final List<Menu> items;

  CategoryMenu({required this.category, required this.items});
}

final List<CategoryMenu> demoCategoryMenus = [
  CategoryMenu(
    category: "Academics",
    items: [
      Menu(
        title: "Academic Calender",
        url: "http://www.srkrec.edu.in/academic_calendar.php",
      ),
      Menu(
        title: "Syllabus",
        url: "http://www.srkrec.edu.in/syllabus.php",
      ),
      Menu(
        title: "Regulations",
        url: "http://www.srkrec.edu.in/regulations.php",
      ),
      Menu(
        title: "Time Tables",
        url: "http://www.srkrec.edu.in/timetables.php",
      ),
      Menu(
        title: "Exam Notification",
        url: "http://www.srkrexams.in/Login.aspx",
      ),
      Menu(
        title: "Department",
        url: "http://www.srkrec.edu.in/departments.php",
      ),
      Menu(
        title: "UG courses",
        url: "http://www.srkrec.edu.in/ug_courses.php",
      ),
      Menu(
        title: "PG courses",
        url: "http://www.srkrec.edu.in/pg_courses.php",
      ),
      Menu(
        title: "PHD courses",
        url: "http://www.srkrec.edu.in/phd_courses.php",
      ),
    ],
  ),
  // CategoryMenu(
  //   category: "Admissions",
  //   items: [
  //     Menu(
  //       title: "Courses offered",
  //       url: "http://www.srkrec.edu.in/coursesoffered.php",
  //     ),
  //     Menu(
  //       title: "Admission Procedure",
  //       url: "http://www.srkrec.edu.in/admission_procedure.php",
  //     ),
  //     Menu(
  //       title: "Intake & Fee",
  //       url: "http://www.srkrec.edu.in/intake.php",
  //     ),
  //     Menu(
  //       title: "Online fee payment",
  //       url: "http://www.srkrec.edu.in/fee_payment.php",
  //     ),
  //     Menu(
  //       title: "Eamcet Rank cut-off details",
  //       url: "http://www.srkrec.edu.in/eamcet_rank.php",
  //     ),
  //     Menu(
  //       title: "contact",
  //       url: "http://www.srkrec.edu.in/contact.php",
  //     ),
  //   ],
  // ),
  CategoryMenu(
    category: "Placements",
    items: [
      Menu(
        title: "Placements",
        url: "http://www.srkrec.edu.in/placements_home.php",
      ),
      Menu(
        title: "VISION & MISSION",
        url: "http://www.srkrec.edu.in/placements_vision.php",
      ),
      Menu(
        title: "PLACEMENT STATS",
        url: "http://www.srkrec.edu.in/placements_details.php",
      ),
      Menu(
        title: "OUR RECRUITERS",
        url: "http://www.srkrec.edu.in/our_recruiters.php",
      ),
      Menu(
        title: "PLACEMENT TEAM",
        url: "http://www.srkrec.edu.in/placement_team.php",
      ),
      Menu(
        title: "INFRASTRUCTURE",
        url: "http://www.srkrec.edu.in/placements_infrastructure.php",
      ),
      Menu(
        title: "ACHIEVEMENTS",
        url: "http://www.srkrec.edu.in/placements_achievements.php",
      ),
      Menu(
        title: "PROMINENT ALUMNI",
        url: "http://www.srkrec.edu.in/prominent_alumni.php",
      ),
      Menu(
        title: "ACTIVITIES",
        url: "http://www.srkrec.edu.in/placements_activities.php",
      ),
      Menu(
        title: "CONTACT",
        url: "http://www.srkrec.edu.in/placements_contact.php",
      ),
    ],
  ),
  CategoryMenu(
    category: "Research",
    items: [
      Menu(
        title: "Research Apex Committee",
        url: "http://www.srkrec.edu.in/rdteam.php",
      ),
      Menu(
        title: "CENTRE FOR RESEARCH AND DEVELOPMENT(CRD)",
        url: "http://www.srkrec.edu.in/research_development.php",
      ),
      Menu(
        title: "R & D Cycle",
        url: "http://www.srkrec.edu.in/rd_cycle.php",
      ),
      Menu(
        title: "RESEARCH CENTRES OF EXCELLENCE",
        url: "http://www.srkrec.edu.in/research_centres.php",
      ),
      Menu(
        title: "Research Projects",
        url: "http://www.srkrec.edu.in/research_projects.php",
      ),
      Menu(
        title: "Workshops & Seminars",
        url: "http://www.srkrec.edu.in/research_workshops.php",
      ),
      Menu(
        title: "CONSULTANCY PROJECTS",
        url: "http://www.srkrec.edu.in/consultancy_projects.php",
      ),
      Menu(
        title: "RESEARCH PUBLICATIONS",
        url: "http://www.srkrec.edu.in/research_publications.php",
      ),
      Menu(
        title: "PATENTS",
        url: "http://www.srkrec.edu.in/patents.php",
      ),
      Menu(
        title: "PhD Students Enrolled",
        url: "http://www.srkrec.edu.in/phds_enrolled.php",
      ),
      Menu(
        title: "PhD Students Awarded",
        url: "http://www.srkrec.edu.in/phds_awarded.php",
      ),
      Menu(
        title: "UBA Cell",
        url: "http://www.srkrec.edu.in/uba_cell.php",
      ),
    ],
  ),
  CategoryMenu(
    category: "AMENITIES",
    items: [
      Menu(
        title: "ALUMNI ASSOCIATION",
        url: "http://www.srkrec.edu.in/alumni.php",
      ),
      Menu(
        title: "HOSTELS",
        url: "http://www.srkrec.edu.in/hostels.php",
      ),
      Menu(
        title: "LABS & CLASS ROOMS",
        url: "http://www.srkrec.edu.in/labs_classrooms.php",
      ),
      Menu(
        title: "TECHNOLOGY CENTRE",
        url: "http://www.srkrec.edu.in/tech.php",
      ),
      Menu(
        title: "LIBRARY",
        url: "http://www.srkrec.edu.in/library.php",
      ),
      Menu(
        title: "General Computer Centre",
        url: "http://www.srkrec.edu.in/gcc.php",
      ),
      Menu(
        title: "DIGITAL LEARNING CENTRE",
        url: "http://www.srkrec.edu.in/digital_learningcentre.php",
      ),
      Menu(
        title: "ICT Facilities & Resources",
        url: "http://www.srkrec.edu.in/ict_tools.php",
      ),
      Menu(
        title: "SEMINAR HALLS",
        url: "http://www.srkrec.edu.in/seminar_halls.php",
      ),
      Menu(
        title: "NSS PROFILE",
        url: "http://www.srkrec.edu.in/nss.php",
      ),
      Menu(
        title: "Infrastructure Pics",
        url: "http://www.srkrec.edu.in/infrastructure.php",
      ),
    ],
  ),
  CategoryMenu(
    category: "ABOUT SRKR",
    items: [
      Menu(
        title: "Vision and Mission",
        url: "http://www.srkrec.edu.in/vision_mission.php",
      ),
      Menu(
        title: "Foot Prints of SRKR",
        url: "http://www.srkrec.edu.in/footprints.php",
      ),
      Menu(
        title: "College Profile",
        url: "http://www.srkrec.edu.in/college_profile.php",
      ),
      Menu(
        title: "GOVERNING BODY",
        url: "http://www.srkrec.edu.in/governing_body.php",
      ),
      Menu(
        title: "COLLEGE ADVISORY COUNCIL",
        url: "http://www.srkrec.edu.in/advisory_council.php",
      ),
      Menu(
        title: "COMMITTEES",
        url: "http://www.srkrec.edu.in/college_committees.php",
      ),
      Menu(
        title: "ORGANOGRAM",
        url: "http://www.srkrec.edu.in/organogram.php",
      ),
      Menu(
        title: "President's Message",
        url: "http://www.srkrec.edu.in/president_message.php",
      ),
      Menu(
        title: "Principal's Message",
        url: "http://www.srkrec.edu.in/principal_message.php",
      ),
      Menu(
        title: "AWARDS & HONOURS",
        url: "http://www.srkrec.edu.in/awards_honours.php",
      ),
      Menu(
        title: "Prominent Alumni",
        url: "http://www.srkrec.edu.in/prominent_alumni.php",
      ),
      Menu(
        title: "MANDATORY DISCLOSURES",
        url: "http://www.srkrec.edu.in/nirf.php",
      ),
    ],
  ),
];

class RestaurantCategories extends SliverPersistentHeaderDelegate {
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  RestaurantCategories({required this.onChanged, required this.selectedIndex});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 40,
      color: const Color.fromRGBO(8, 24, 51, 0.8),
      child: Categories(onChanged: onChanged, selectedIndex: selectedIndex),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class MenuCategoryItem extends StatelessWidget {
  const MenuCategoryItem({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  final String title;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: InkWell(
        child: Container(
          width: double.infinity,
          //alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFE0F2F1).withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 50, top: 10, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        onTap: () {
          _launchUrl(url);
        },
      ),
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({
    Key? key,
    required this.onChanged,
    required this.selectedIndex,
  }) : super(key: key);

  final ValueChanged<int> onChanged;
  final int selectedIndex;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedIndex = 0;
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Categories oldWidget) {
    _controller.animateTo(
      80.0 * widget.selectedIndex,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 200),
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          demoCategoryMenus.length,
          (index) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: TextButton(
              onPressed: () {
                widget.onChanged(index);
                // _controller.animateTo(
                //   80.0 * index,
                //   curve: Curves.ease,
                //   duration: const Duration(milliseconds: 200),
                // );
              },
              style: TextButton.styleFrom(primary: widget.selectedIndex == index ? Colors.white : Colors.white30),
              child: Text(
                demoCategoryMenus[index].category,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white60,
            child: Image.asset(
              "assets/srkrec_full_name.png",
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, top: 13, bottom: 5),
                child: Text(
                  "FLASH NEWS:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white70),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 13, bottom: 5),
                child: Text(
                  "Click Here",
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Spacer(),
              if (userId() == "gmail.com")InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 27,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FlashNewsEdit()));
                  })
            ],
          ),
          StreamBuilder<List<FlashConvertor>>(
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
                      return CarouselSlider(
                        items: List.generate(
                          user!.length,
                          (int index) {
                            return InkWell(
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      user[index].heading,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                _launchUrl(user[index].link);
                              },
                            );
                          },
                        ),
                        //Slider Container properties
                        options: CarouselOptions(
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                          height: 55,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlay: true,
                        ),
                      );
                    }
                }
              }),
          const SizedBox(
            height: 13,
          ),
        ],
      ),
    );
  }
}

class FlashNewsEdit extends StatefulWidget {
  FlashNewsEdit({Key? key}) : super(key: key);

  @override
  State<FlashNewsEdit> createState() => _FlashNewsEditState();
}

class _FlashNewsEditState extends State<FlashNewsEdit> {
  final FlashHeadingController = TextEditingController();

  final FlashLinkController = TextEditingController();

  @override
  void dispose() {
    FlashHeadingController.dispose();
    FlashLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: Color.fromRGBO(7, 7, 23, 1.0),
            ),
          ),
          title: Text(
            "Flash News Editor",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  controller: FlashHeadingController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Heading or Data',
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: TextFormField(
                  obscureText: true,
                  controller: FlashLinkController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Link',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6 ? "Enter min. 6 characters" : null,
                ),
              ),
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: InkWell(
                    child: Text("create"),
                    onTap: () {
                      createFlashNews(heading: FlashHeadingController.text.trim(), link: FlashLinkController.text.trim());
                    },
                  ),
                ),
              ],
            ),
            StreamBuilder<List<FlashConvertor>>(
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
                              final loadFlashData = user[index];
                              return InkWell(
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(25),
                                      right: Radius.circular(25),
                                    ),
                                    color: Colors.black.withOpacity(0.05),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(loadFlashData.id),
                                      Text(loadFlashData.heading),
                                      Text(loadFlashData.link),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: InkWell(
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
                                                final deleteFlashNews = FirebaseFirestore.instance.collection("SRKR Page Flash News").doc(loadFlashData.id);
                                                deleteFlashNews.delete();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
    );
  }

  Widget buildFlashNewsList(FlashConvertor FlashData) => ListTile(
        title: Text(FlashData.heading),
        subtitle: Text(FlashData.link),
      );

  Future createFlashNews({required String heading, required String link}) async {
    final docflash = FirebaseFirestore.instance.collection("SRKR Page Flash News").doc();
    final flash = FlashConvertor(id: docflash.id, heading: heading, link: link);
    final json = flash.toJson();
    await docflash.set(json);
  }
}

Stream<List<FlashConvertor>> readFlashNews() =>
    FirebaseFirestore.instance.collection('SRKR Page Flash News').snapshots().map((snapshot) => snapshot.docs.map((doc) => FlashConvertor.fromJson(doc.data())).toList());

class FlashConvertor {
  String id;
  final String heading, link;

  FlashConvertor({
    this.id = '',
    required this.heading,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "link": link,
      };

  static FlashConvertor fromJson(Map<String, dynamic> json) => FlashConvertor(id: json['id'], heading: json["heading"], link: json['link']);
}

_launchUrl(String urlIn) async {
  final Uri url = Uri.parse(urlIn);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) throw 'Could not launch $url';
}
