import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextStyle favoritesHeadingTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 30,
    fontWeight: FontWeight.w600);

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
    {required id,
      required regulation,
    required name,
    required description,
    required creator,
    required branch
    }) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteSubject")
      .doc(id);
  final flash = FavouriteSubjectsConvertor(
      id: id,
    regulation: regulation,
      name: name,
      description: description,
      branch: branch, creator: creator,);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteSubjectsConvertor {
  String id;
  final String regulation, name, description, branch,creator;

  FavouriteSubjectsConvertor(
      {this.id = "",
      required this.regulation,
      required this.creator,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "regulation": regulation,
        "description": description,
        "creator": creator,
        "name": name,
        "branch": branch
      };

  static FavouriteSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteSubjectsConvertor(
          id: json['id'],
          regulation: json["regulation"]??"",
          creator: json["creator"]??"",
          branch: json['branch']??"",
          name: json["name"]??"",
          description: json["description"]??"");
}

Stream<List<FavouriteSubjectsConvertor>> readFavouriteLabSubjects() =>
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email!)
        .collection("FavouriteLabSubjects")
        .orderBy("name", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteSubjectsConvertor.fromJson(doc.data()))
            .toList());

Future FavouriteLabSubjectsSubjects(
    {required id,
      required regulation,
    required name,
    required creator,
    required description,
    required branch}) async {
  final docflash = FirebaseFirestore.instance
      .collection("user")
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection("FavouriteLabSubjects")
      .doc(id);
  final flash = FavouriteSubjectsConvertor(
      id: id,
    regulation: regulation,
      name: name,
      description: description,
      branch: branch, creator: creator,);
  final json = flash.toJson();
  await docflash.set(json);
}


