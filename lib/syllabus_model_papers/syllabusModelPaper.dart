import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/subjects/subjects.dart';
import 'package:srkr_study_app/uploader.dart';
import '../get_all_data.dart';

class SyllabusAndModelPaper extends StatefulWidget {
  final List<SyllabusConverter> data;

  const SyllabusAndModelPaper({required this.data});

  @override
  State<SyllabusAndModelPaper> createState() => _SyllabusAndModelPaperState();
}

class _SyllabusAndModelPaperState extends State<SyllabusAndModelPaper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Heading(heading: "Syllabus & Model Papers"),
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(left: 15.0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.data.length,
                    reverse: true,
                    itemBuilder: (context, int index) {
                      final data = widget.data[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(heading: data.heading,padding: EdgeInsets.zero,),
                          SizedBox(
                            height: 250,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.syllabusPaper.length,
                                      itemBuilder: (context, int index) {
                                        final FileUploader s = data.syllabusPaper[index];
                                        return pdfContainer(data:s);
                                      }),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.modelPaper.length,
                                      itemBuilder: (context, int index) {
                                        final FileUploader s = data.modelPaper[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: pdfContainer(data:s),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),

                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
