// ignore_for_file: camel_case_types, non_constant_identifier_names, must_be_immutable


import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/subjects/subjects.dart';
import 'package:srkr_study_app/uploader.dart';
import 'package:flutter/material.dart';
import 'functions.dart';




class allBooks extends StatefulWidget {
  final List<FileUploader> books;


  const allBooks({

    required this.books,
  });

  @override
  State<allBooks> createState() => _allBooksState();
}

class _allBooksState extends State<allBooks> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backButton(),
              Heading(heading: "Books"),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 8.5 / 11.5,
                ),
                itemCount: widget.books.length,
                itemBuilder: (BuildContext context, int index) {
                  return pdfContainer(data:widget.books[index]);
                },
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


