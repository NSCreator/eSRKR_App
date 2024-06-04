import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/subjects/convertors.dart';

import 'functions.dart';
import 'uploader.dart';

Future<BranchStudyMaterialsConverter?> getBranchStudyMaterials(
    bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final studyMaterialsJson = await prefs.getString("studyMaterials");
  final branch = getBranch(fullUserId());

  if (studyMaterialsJson == null || isLoading) {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("StudyMaterials")
          .doc(branch)
          .get();
      if (documentSnapshot.exists) {
        // var documentData = documentSnapshot.data();
        try {
          final subjectsQuery =
              await documentSnapshot.reference.collection("Subjects").get();
          final labSubjectsQuery =
              await documentSnapshot.reference.collection("LabSubjects").get();
          final booksQuery =
              await documentSnapshot.reference.collection("Books").get();
          final homePageImagesQuery = await documentSnapshot.reference
              .collection("HomePageImages")
              .get();
          final syllabusModelPapersQuery = await documentSnapshot.reference
              .collection("SyllabusModelPapers")
              .get();

          final subjects = await subjectsQuery.docs
              .map((doc) => SubjectConverter.fromJson(doc.data()))
              .toList();
          final labSubjects = await labSubjectsQuery.docs
              .map((doc) => SubjectConverter.fromJson(doc.data()))
              .toList();
          final books = await booksQuery.docs
              .map((doc) => FileUploader.fromJson(doc.data()))
              .toList();
          final homePageImages = await homePageImagesQuery.docs
              .map((doc) => FileUploader.fromJson(doc.data()))
              .toList();
          final syllabusModelPapers = await syllabusModelPapersQuery.docs
              .map((doc) => SyllabusConverter.fromJson(doc.data()))
              .toList();

          final data = await BranchStudyMaterialsConverter(
              subjects: subjects,
              labSubjects: labSubjects,
              books: books,
              syllabusModelPapers:syllabusModelPapers,
              homePageImages: homePageImages);

          String studyMaterialsJson = await json.encode(data.toJson());
          await prefs.setString("studyMaterials", studyMaterialsJson);
          return data;
        } catch (e) {
          print("Error processing data: $e");
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting study materials: $e");
      return null;
    }
  } else {
    return await BranchStudyMaterialsConverter.fromJson(
        json.decode(studyMaterialsJson));
  }
}

class BranchStudyMaterialsConverter {
  List<SubjectConverter> subjects;
  List<SubjectConverter> labSubjects;
  List<FileUploader> books;
  List<FileUploader> homePageImages;
  List<SyllabusConverter> syllabusModelPapers;

  BranchStudyMaterialsConverter({
    required this.subjects,
    required this.labSubjects,
    required this.books,
    required this.homePageImages,
    required this.syllabusModelPapers,
  });

  Map<String, dynamic> toJson() {
    return {
      "Subjects": subjects.map((subject) => subject.toJson()).toList(),
      "LabSubjects":
          labSubjects.map((labSubject) => labSubject.toJson()).toList(),
      "Books": books.map((book) => book.toJson()).toList(),
      "HomePageImages": homePageImages
          .map((homePageImage) => homePageImage.toJson())
          .toList(),
      "SyllabusModelPapers": syllabusModelPapers
          .map((syllabusModelPaper) => syllabusModelPaper.toJson())
          .toList(),
    };
  }

  static BranchStudyMaterialsConverter fromJson(Map<String, dynamic> json) {
    return BranchStudyMaterialsConverter(
      subjects: (json['Subjects'] as List<dynamic>?)
              ?.map((item) => SubjectConverter.fromJson(item))
              .toList() ??
          [],
      syllabusModelPapers: (json['SyllabusModelPapers'] as List<dynamic>?)
              ?.map((item) => SyllabusConverter.fromJson(item))
              .toList() ??
          [],
      labSubjects: (json['LabSubjects'] as List<dynamic>?)
              ?.map((item) => SubjectConverter.fromJson(item))
              .toList() ??
          [],
      books: (json['Books'] as List<dynamic>?)
              ?.map((item) => FileUploader.fromJson(item))
              .toList() ??
          [],
      homePageImages: (json['HomePageImages'] as List<dynamic>?)
              ?.map((item) => FileUploader.fromJson(item))
              .toList() ??
          [],
    );
  }

  static List<BranchStudyMaterialsConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
class SyllabusConverter {
  final String id;
  final String heading;
  final List<FileUploader> syllabusPaper;
  final List<FileUploader> modelPaper;

  SyllabusConverter({
    required this.id,
    required this.heading,
    required this.syllabusPaper,
    required this.modelPaper,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "heading": heading,
    "syllabusPapers": syllabusPaper.map((uploader) => uploader.toJson()).toList(),
    "modelPapers": modelPaper.map((uploader) => uploader.toJson()).toList(),
  };

  static SyllabusConverter fromJson(Map<String, dynamic> json) => SyllabusConverter(
    id: json['id'] ?? "",
    heading: json["heading"] ?? "",
    syllabusPaper: (json['syllabusPapers'] as List<dynamic>?)
        ?.map((item) => FileUploader.fromJson(item))
        .toList() ??
        [],
    modelPaper: (json['modelPapers'] as List<dynamic>?)
        ?.map((item) => FileUploader.fromJson(item))
        .toList() ??
        [],
  );

  static List<SyllabusConverter> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

