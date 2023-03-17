// ignore_for_file: camel_case_types
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class notification extends StatefulWidget {

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  int TabCurrentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
          color: Colors.black
      ),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35,top: 5),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: TabBar(
                          indicator: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(15)),
                          onTap: (index) {
                            setState(() {
                              TabCurrentIndex = index;
                            });
                          },
                          tabs: [
                            Tab(text: "Branch"),
                            Tab(text: "College"),
                          ]),
                    ),
                  ),
                ),
                SizedBox(height: 3,),


              ],
            ),
          ),
        ),
      ),
    );
  }


}


class addSubjects {
  String name, lastdate, description, regulation, pdfs, units;

  addSubjects(
      {required this.name,
        required this.description,
        required this.lastdate,
        required this.regulation,
        required this.pdfs,
        required this.units});

  static addSubjects fromJson(json) => addSubjects(
    name: json['name'],
    description: json['description'],
    regulation: json['regulation'],
    pdfs: json['pdfs'],
    units: json['units'],
    lastdate: json['updated'],
  );
}


_externalLaunchUrl(String url) async {
  final Uri urlIn = Uri.parse(url);
  if (!await launchUrl(urlIn,mode: LaunchMode.externalApplication)) throw 'Could not launch $urlIn';
}