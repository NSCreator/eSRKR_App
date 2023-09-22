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
    {
      required SubjectId,
    required name,
    required description,
    required branch
    }) async {
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
      branch: branch,);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteSubjectsConvertor {
  String id;
  final String subjectId, name, description, branch;

  FavouriteSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "branch": branch
      };

  static FavouriteSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
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
      branch: branch,);
  final json = flash.toJson();
  await docflash.set(json);
}

class FavouriteLabSubjectsConvertor {
  String id;
  final String subjectId, name, description, branch;

  FavouriteLabSubjectsConvertor(
      {this.id = "",
      required this.subjectId,
      required this.name,
      required this.description,
      required this.branch});

  Map<String, dynamic> toJson() => {
        "id": id,
        "subjectId": subjectId,
        "description": description,
        "name": name,
        "branch": branch
      };

  static FavouriteLabSubjectsConvertor fromJson(Map<String, dynamic> json) =>
      FavouriteLabSubjectsConvertor(
          id: json['id'],
          subjectId: json["subjectId"],
          branch: json['branch'],
          name: json["name"],
          description: json["description"]);
}


