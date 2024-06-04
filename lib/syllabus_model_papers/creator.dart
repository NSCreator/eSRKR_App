import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/get_all_data.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/uploader.dart';

import '../TextField.dart';

class SyllabusModelPaperCreator extends StatefulWidget {
  // const SyllabusModelPaperCreator({super.key});

  @override
  State<SyllabusModelPaperCreator> createState() =>
      _SyllabusModelPaperCreatorState();
}

class _SyllabusModelPaperCreatorState extends State<SyllabusModelPaperCreator> {
  final HeadingController = TextEditingController();
   List<FileUploader> syllabus=[];
   List<FileUploader>model=[];

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
              Heading(heading: "Create Syllabus & Model Paper"),
              TextFieldContainer(
                child: TextFormField(
                  controller: HeadingController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                heading: "Short Name",
              ),
              Heading(heading: "Syllabus Paper"),
              Uploader(
                IVF:syllabus,
                type: FileType.any,
                allowMultiple: true,
                token: esrkr,
                path: "pdf",
                getIVF: (data) {
                  setState(() {
                    syllabus.addAll(data);
                  });
                },
              ),
              Heading(heading: "Model Paper"),
              Uploader(
                IVF:model,
                type: FileType.any,
                token: esrkr,
                allowMultiple: true,
                path: "pdf",
                getIVF: (data) {
                  setState(() {
                    model.addAll(data);
                  });
                },
              ),
          
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          String id = getID();
                          print(syllabus);
                          print(model);
                          await firestore
                              .collection("StudyMaterials")
                              .doc(getBranch(fullUserId()))
                              .collection("SyllabusModelPapers")
                              .doc(id)
                              .set(SyllabusConverter(
                                      id: id,
                                      heading: HeadingController.text,
                                      syllabusPaper: syllabus!,
                                      modelPaper: model!)
                                  .toJson());
                          Navigator.pop(context);
                        },
                        child: Text("Save")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
