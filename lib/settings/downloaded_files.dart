import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/uploader.dart';

import '../get_all_data.dart';
import '../subjects/convertors.dart';

class PdfFileList extends StatefulWidget {
  @override
  _PdfFileListState createState() => _PdfFileListState();
}

class _PdfFileListState extends State<PdfFileList> {
  List<File> pdfFiles = [];
  List<File> RemainingFiles = [];
  List<FileUploader> FilteredFiles = [];

  int totalSize = 0;
  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  Future<void> _loadPdfFiles() async {
    totalSize =0;
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      Directory pdfDir = Directory('${appDocDir.path}/pdfs');
      if (await pdfDir.exists()) {
        setState(() async {
          pdfFiles = pdfDir.listSync().whereType<File>().toList();
          for (File file in pdfFiles) {
            totalSize += await file.length();
          }
          getFiles();
        });
      } else {
        print("Directory does not exist");
      }
    } catch (e) {
      print("Error loading PDF files: $e");
    }
  }

getFiles() async {
  FilteredFiles =[];
  try {
    BranchStudyMaterialsConverter? data =
        await getBranchStudyMaterials(false);
    if (data != null) {
      List<SubjectConverter> subjects = data.subjects;
      for (var subject in subjects) {

        List<FileUploader> UnitFiles = subject.units.toList();
        for (var pdfFilePath in pdfFiles) {
          var fileName = pdfFilePath.path.split("/").last;
          UnitFiles.forEach((file) {
            if (file.url == fileName) {
              FilteredFiles.add(file);
            }
          });
        }
        List<FileUploader> TextBooksFiles = subject.textBooks.toList();
        for (var pdfFilePath in pdfFiles) {
          var fileName = pdfFilePath.path.split("/").last;
          TextBooksFiles.forEach((file) {
            if (file.url == fileName) {
              FilteredFiles.add(file);
            }
          });
        }

      }
      List<SubjectConverter> labSubjects = data.labSubjects;
      for (var labSubject in labSubjects) {

        List<FileUploader> UnitFiles = labSubject.units.toList();
        for (var pdfFilePath in pdfFiles) {
          var fileName = pdfFilePath.path.split("/").last;
          UnitFiles.forEach((file) {
            if (file.url == fileName) {
              FilteredFiles.add(file);
            }
          });
        }
        List<FileUploader> TextBooksFiles = labSubject.textBooks.toList();
        for (var pdfFilePath in pdfFiles) {
          var fileName = pdfFilePath.path.split("/").last;
          TextBooksFiles.forEach((file) {
            if (file.url == fileName) {
              FilteredFiles.add(file);
            }
          });
        }

      }
      RemainingFiles = [];
      for (final filex in pdfFiles) {
        bool found = false;
        for (final file in FilteredFiles) {
          if (filex.path.split("/").last == file.url) {
            found = true;
            break;
          }
        }
        if (!found) {
          RemainingFiles.add(filex);
        }
      }


      setState(() {
        RemainingFiles;
        FilteredFiles;
      });
    } else {
      print("No data found for the specified branch.");
    }
  } catch (e) {
    print("Error getting subjects: $e");
  }

}
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Heading(heading: "Download Files"),
                  Heading(heading: "Total Size : ${formatFileSize(totalSize)}"),
                ],
              ),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Text("Note: We are testing, so there may be errors. We apologize for any inconvenience and assure you that we will fix them soon.",style: TextStyle(color: Colors.white70),),
             ),
             if(FilteredFiles.isNotEmpty) Heading(heading: "Subjects & Lab Files"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: FilteredFiles.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        margin:EdgeInsets.only(left: 15,bottom: 3,right: 10) ,
                        padding: EdgeInsets.all(2),
                        height: 80,
                        width: 70,
                        color: Colors.black.withOpacity(0.1),
                        child: FilteredFiles[index].thumbnailUrl.isNotEmpty?ImageShowAndDownload(image: FilteredFiles[index].thumbnailUrl, token: esrkr,):null,
                      ),
                      Expanded(child: Row(
                        children: [
                          Expanded(child: Text(FilteredFiles[index].fileName,style: TextStyle(fontSize: 18,color: Colors.white70),)),
                          InkWell(
                            onTap: () async {
                              Directory appDocDir = await getApplicationDocumentsDirectory();
                              Directory pdfDir = Directory('${appDocDir.path}/pdfs');
                              String filePathToDelete = "${pdfDir.path}/${FilteredFiles[index].url}";
                              File fileToDelete = File(filePathToDelete);
                              if (await fileToDelete.exists()) {
                                await fileToDelete.delete();
                                showToastText('File deleted');
                              } else {
                                showToastText('File not found');
                              }
                              _loadPdfFiles();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.delete,color: Colors.orangeAccent,),
                            ),
                          )
                        ],
                      ))
                    ],
                  );
                },
              ),
              if(RemainingFiles.isNotEmpty)Heading(heading: "Remaining Files"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: RemainingFiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Text(RemainingFiles[index].path.split("/").last,style: TextStyle(fontSize: 18,color: Colors.white70),)),
                        InkWell(
                          onTap: () async {

                            File fileToDelete = File(RemainingFiles[index].path);
                            if (await fileToDelete.exists()) {
                              await fileToDelete.delete();
                              showToastText('File deleted');
                            } else {
                              showToastText('File not found');
                            }
                            _loadPdfFiles();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete,color: Colors.orangeAccent,),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}