
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/subjects/convertors.dart';
import 'package:srkr_study_app/uploader.dart';

import '../TextField.dart';
import '../functions.dart';



class SubjectCreator extends StatefulWidget {
  SubjectConverter? data;
  bool isSub;

  SubjectCreator({
    this.data,
    this.isSub = true,
  });

  @override
  State<SubjectCreator> createState() => _SubjectCreatorState();
}

class _SubjectCreatorState extends State<SubjectCreator> {
  List<FileUploader> Units = [];
  List<FileUploader> TextBooks = [];
  List<MoreInfoConvertor> MoreInfos = [];
  final ShortHeadingController = TextEditingController();
  final FullHeadingController = TextEditingController();
  final DescriptionController = TextEditingController();
  final EditAccessController = TextEditingController();
  final BranchAccessController = TextEditingController();

  List<String> EditAccess = [];
  List<String> Regulation = [];
  List<String> BranchAccess = [];

  void AutoFill() async {
    ShortHeadingController.text = widget.data!.heading.short;
    FullHeadingController.text = widget.data!.heading.full;
    DescriptionController.text = widget.data!.description;
    Units = widget.data!.units;
    TextBooks = widget.data!.textBooks;
    MoreInfos = widget.data!.moreInfos;
    EditAccess = widget.data!.createdByAndPermissions.EditAccess;
    descriptionList = widget.data!.oldPapers;
    setState(() {});
  }

  @override
  void initState() {
    if (widget.data != null) {
      AutoFill();
    }
    super.initState();
  }

  bool isEdit = false;

  @override
  void dispose() {
    ShortHeadingController.dispose();
    DescriptionController.dispose();
    super.dispose();
  }

  bool _switch1Value = false;
  List<OldPapersConvertor> descriptionList = [];
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _pdfLinkController = TextEditingController();
  int selectedDescriptionIndex = -1;

  void addDescription() {
    String heading = _headingController.text;
    String pdfLink = _pdfLinkController.text;

    if (heading.isNotEmpty && pdfLink.isNotEmpty) {
      setState(() {
        descriptionList
            .add(OldPapersConvertor(heading: heading, pdfLink: pdfLink));
        _headingController.clear();
        _pdfLinkController.clear();
      });
    }
  }

  void editDescription(int index) {
    setState(() {
      selectedDescriptionIndex = index;
      _headingController.text = descriptionList[index].heading;
      _pdfLinkController.text = descriptionList[index].pdfLink;
    });
  }

  void saveDescription() {
    String editedHeading = _headingController.text;
    String editedPdfLink = _pdfLinkController.text;

    if (editedHeading.isNotEmpty &&
        editedPdfLink.isNotEmpty &&
        selectedDescriptionIndex != -1) {
      setState(() {
        descriptionList[selectedDescriptionIndex] =
            OldPapersConvertor(heading: editedHeading, pdfLink: editedPdfLink);
        _headingController.clear();
        _pdfLinkController.clear();
        selectedDescriptionIndex = -1;
      });
    }
  }

  void deleteDescription(int index) {
    setState(() {
      descriptionList.removeAt(index);
      if (selectedDescriptionIndex == index) {
        selectedDescriptionIndex = -1;
        _headingController.clear();
        _pdfLinkController.clear();
      }
    });
  }

  void moveDescriptionUp(int index) {
    if (index > 0) {
      setState(() {
        OldPapersConvertor description = descriptionList.removeAt(index);
        descriptionList.insert(index - 1, description);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex--;
        }
      });
    }
  }

  void moveDescriptionDown(int index) {
    if (index < descriptionList.length - 1) {
      setState(() {
        OldPapersConvertor description = descriptionList.removeAt(index);
        descriptionList.insert(index + 1, description);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex++;
        }
      });
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
              backButton(
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFieldContainer(
                      child: TextFormField(
                        controller: ShortHeadingController,
                        textInputAction: TextInputAction.next,

                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),
                      heading: "Short Name",
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextFieldContainer(
                      child: TextFormField(
                        controller: FullHeadingController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),
                      heading: "Full Name",
                    ),
                  ),
                ],
              ),
              TextFieldContainer(
                child: TextFormField(
                  //obscureText: true,
                  controller: DescriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: null,
                  style: TextStyle(color: Colors.black, fontSize: 20),

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
                heading: "Description",
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Units",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
              ),


              Uploader(
                IVF: Units,
                token: esrkr,
                path: widget.isSub?"subjects":"labSubjects",
                type: FileType.any,
                allowMultiple: true,
                getIVF: (file) {
                  Units.addAll(file);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("TextBooks",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
              ),
              if(TextBooks.isNotEmpty)ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: TextBooks.length,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    return Row(
                      children: [
                        Expanded(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(TextBooks[index].thumbnailUrl))),
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text("${TextBooks[index].fileMessageId}"),
                                InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: TextBooks[index].thumbnailUrl));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Copied to clipboard'),
                                        ),
                                      );
                                    },
                                    child: Text("${TextBooks[index].thumbnailUrl}")),
                                InkWell(
                                  onTap: () async {
                                    await deleteFileFromTelegramBot(
                                        TextBooks[index].fileMessageId);

                                    setState(() {
                                      TextBooks.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Text(
                                        " Remove",
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ),
                              ],
                            )),
                      ],
                    );
                  }),

              Uploader(
                IVF: TextBooks,
                token: esrkr,
                path: widget.isSub?"subjects_textbooks":"labSubjects_textbooks",
                type: FileType.any,
                allowMultiple: true,
                getIVF: (file) {
                  TextBooks.addAll(file);
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Subjects Accessing ( Optional )",
                      style: TextStyle(color: Colors.black87, fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: Text(
                        "Created By ${fullUserId()}",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFieldContainer(
                            child: TextFormField(
                              controller: EditAccessController,
                              textInputAction: TextInputAction.next,
                              style:
                              TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter gmail id',
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                            heading: "Please enter the ID for editing access.",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Save the entered text to the list
                            saveEditAccess();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: EditAccess.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            EditAccess[index],
                            style:
                            TextStyle(color: Colors.black54, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              deleteEditAccess(index);
                            },
                          ),
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFieldContainer(
                            child: TextFormField(
                              controller: BranchAccessController,
                              textInputAction: TextInputAction.next,
                              style:
                              TextStyle(color: Colors.black, fontSize: 20),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Branch (ece or ECE)',
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                            heading:
                            "Enter the branches that can access this Subject.",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Save the entered text to the list
                            saveBranchAccess();
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: BranchAccess.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            BranchAccess[index],
                            style:
                            TextStyle(color: Colors.black54, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              deleteBranchAccess(index);
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                "Is Downloadable",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              )),
                          CupertinoSwitch(
                            value: _switch1Value,
                            onChanged: (value) {
                              setState(() {
                                _switch1Value = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                    ),
                    child: Text("Back"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {

                        CreateSubject(
                            isUpdate: widget.data != null,
                            isSub: widget.isSub,
                            id: widget.data != null ? widget.data!.id : getID(),
                            Branch: getBranch(fullUserId()),
                            Heading: HeadingConvertor(
                                full: FullHeadingController.text,
                                short: ShortHeadingController.text),
                            Description: DescriptionController.text,
                            MoreInfos: MoreInfos,
                            TextBooks: TextBooks,
                            Units: Units,
                            CreatedByAndPermissions:
                            CreatedByAndPermissionsConvertor(
                                id: fullUserId(),
                                EditAccess: EditAccess,
                                isDownloadable: _switch1Value),
                            OldPapers: descriptionList);
                        ShortHeadingController.clear();
                        DescriptionController.clear();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: widget.data == null
                          ? Text("Create")
                          : Text("Update")),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveEditAccess() {
    String enteredText = EditAccessController.text;
    if (enteredText.isNotEmpty) {
      setState(() {
        EditAccess.add(enteredText);
        EditAccessController.clear();
      });
    }
  }

  void deleteEditAccess(int index) {
    setState(() {
      EditAccess.removeAt(index);
    });
  }

  void deleteRegulation(int index) {
    setState(() {
      Regulation.removeAt(index);
    });
  }

  void saveBranchAccess() {
    String enteredText = BranchAccessController.text;
    if (enteredText.isNotEmpty) {
      setState(() {
        BranchAccess.add(enteredText);
        BranchAccessController.clear();
      });
    }
  }

  void deleteBranchAccess(int index) {
    setState(() {
      EditAccess.removeAt(index);
    });
  }
}
class BooksCreator extends StatefulWidget {

  String branch;

  BooksCreator(
      {
        required this.branch,
      });
  @override
  State<BooksCreator> createState() => _BooksCreatorState();
}

class _BooksCreatorState extends State<BooksCreator> {
  late FileUploader data;
  final HeadingController = TextEditingController();



  @override
  void dispose() {
    HeadingController.dispose();
    super.dispose();
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
              TextFieldContainer(
                child: TextFormField(
                  controller: HeadingController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors. black, fontSize:   20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Heading',
                      hintStyle: TextStyle(color: Colors. black54)),
                ),
                heading: "Heading",
              ),
              Uploader(
                token: esrkr,
                path: "books",
                type: FileType.any,getIVF: (file){
                setState(() {
                  data = file.first;
                  HeadingController.text= data.fileName;
                });
              },),


              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back")),
                  SizedBox(
                    width:   10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      data.fileName = HeadingController.text;

                      FirebaseFirestore.instance.collection("StudyMaterials").doc(widget.branch).collection("Books").doc(data.fileMessageId.toString()).set(data.toJson());
                      Navigator.pop(context);
                    },
                    child:Text("Create"),
                  ),
                  SizedBox(
                    width:   20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
class UnitsCreator extends StatefulWidget {
  final SubjectConverter subject;
  final FileUploader? unit;
  final FileUploader? textBook;
  final MoreInfoConvertor? moreInfo;
  String subjectId;
  String mode;

  UnitsCreator({
    required this.mode,
    required this.subjectId,
    required this.subject,
    this.unit,
    this.textBook,
    this.moreInfo,
  });

  @override
  State<UnitsCreator> createState() => _UnitsCreatorState();
}

class _UnitsCreatorState extends State<UnitsCreator> {
  String unit = "Unknown";
  bool isEdit = false;
  List list = ["PDF", "Image", "YouTube", "WebSite", "More"];
  final HeadingController = TextEditingController();

  final PDFUrlController = TextEditingController();
  final PhotoUrlController = TextEditingController();
  final AuthorController = TextEditingController();
  final EditionController = TextEditingController();

  // void AutoFill() {
  //   if (widget.mode == "units" && widget.unit != null) {
  //     HeadingController.text = widget.unit!.Heading;
  //     unit = widget.unit!.Unit;
  //     PDFUrlController.text = widget.unit!.Link;
  //     DescriptionList = widget.unit!.Description;
  //   } else if (widget.mode == "textBook" && widget.textBook != null) {
  //     HeadingController.text = widget.textBook!.Heading;
  //     PDFUrlController.text = widget.textBook!.Link;
  //     AuthorController.text = widget.textBook!.Author;
  //     EditionController.text = widget.textBook!.Edition;
  //   } else if (widget.mode == "more" && widget.moreInfo != null) {
  //     HeadingController.text = widget.moreInfo!.Heading;
  //     PDFUrlController.text = widget.moreInfo!.Link;
  //     unit = widget.moreInfo!.Type;
  //   }
  //   setState(() {
  //     DescriptionList;
  //     unit;
  //   });
  // }

  @override
  void initState() {
    // AutoFill();

    super.initState();
  }

  @override
  void dispose() {
    HeadingController.dispose();

    PDFUrlController.dispose();
    super.dispose();
  }

  List<DescriptionAndQuestionConvertor> DescriptionList = [];
  final TextEditingController _DescriptionController = TextEditingController();
  int selectedDescriptionIndex = -1;
  int DescriptionPageNumber = 0;
  int QuestionPageNumber = 0;

  void addDescription() {
    String points = _DescriptionController.text;
    if (points.isNotEmpty) {
      setState(() {
        DescriptionList.add(DescriptionAndQuestionConvertor(
            pageNumber: DescriptionPageNumber, data: points));
        _DescriptionController.clear();
      });
    }
  }

  void editDescription(int index) {
    setState(() {
      selectedDescriptionIndex = index;
      _DescriptionController.text = DescriptionList[index].data;
      DescriptionPageNumber = DescriptionList[index].pageNumber;
    });
  }

  void saveDescription() {
    String editedImage = _DescriptionController.text;
    if (editedImage.isNotEmpty && selectedDescriptionIndex != -1) {
      DescriptionList.removeAt(selectedDescriptionIndex);
      if (selectedDescriptionIndex == selectedDescriptionIndex) {
        selectedDescriptionIndex = -1;
        _DescriptionController.clear();
      }
      setState(() {
        DescriptionList.add(DescriptionAndQuestionConvertor(
            pageNumber: DescriptionPageNumber, data: editedImage));
        _DescriptionController.clear();
        _DescriptionController.clear();
        selectedDescriptionIndex = -1;
        DescriptionPageNumber = 0;
      });
    }
  }

  void deleteDescription(int index) {
    setState(() {
      DescriptionList.removeAt(index);
      if (selectedDescriptionIndex == index) {
        selectedDescriptionIndex = -1;
        _DescriptionController.clear();
      }
    });
  }

  void moveDescriptionUp(int index) {
    if (index > 0) {
      setState(() {
        DescriptionAndQuestionConvertor point = DescriptionList.removeAt(index);
        DescriptionList.insert(index - 1, point);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex--;
        }
      });
    }
  }

  void moveDescriptionDown(int index) {
    if (index < DescriptionList.length - 1) {
      setState(() {
        DescriptionAndQuestionConvertor image = DescriptionList.removeAt(index);
        DescriptionList.insert(index + 1, image);
        if (selectedDescriptionIndex == index) {
          selectedDescriptionIndex++;
        }
      });
    }
  }

  List<String> NormalDescriptionList = [];
  final TextEditingController _NormalDescriptionController =
  TextEditingController();
  int selectedNormalDescriptionIndex = -1;

  void addNormalDescription() {
    String points = _NormalDescriptionController.text;
    if (points.isNotEmpty) {
      setState(() {
        NormalDescriptionList.add(points);
        _NormalDescriptionController.clear();
      });
    }
  }

  void editNormalDescription(int index) {
    setState(() {
      selectedNormalDescriptionIndex = index;
      _NormalDescriptionController.text = NormalDescriptionList[index];
    });
  }

  void saveNormalDescription() {
    String editedImage = _NormalDescriptionController.text;
    if (editedImage.isNotEmpty && selectedNormalDescriptionIndex != -1) {
      setState(() {
        NormalDescriptionList[selectedNormalDescriptionIndex] = editedImage;
        _NormalDescriptionController.clear();
        selectedNormalDescriptionIndex = -1;
      });
    }
  }

  void deleteNormalDescription(int index) {
    setState(() {
      NormalDescriptionList.removeAt(index);
      if (selectedNormalDescriptionIndex == index) {
        selectedNormalDescriptionIndex = -1;
        _NormalDescriptionController.clear();
      }
    });
  }

  void moveNormalDescriptionUp(int index) {
    if (index > 0) {
      setState(() {
        String point = NormalDescriptionList.removeAt(index);
        NormalDescriptionList.insert(index - 1, point);
        if (selectedNormalDescriptionIndex == index) {
          selectedNormalDescriptionIndex--;
        }
      });
    }
  }

  void moveNormalDescriptionDown(int index) {
    if (index < NormalDescriptionList.length - 1) {
      setState(() {
        String Image = NormalDescriptionList.removeAt(index);
        NormalDescriptionList.insert(index + 1, Image);
        if (selectedNormalDescriptionIndex == index) {
          selectedNormalDescriptionIndex++;
        }
      });
    }
  }

  List<DescriptionAndQuestionConvertor> QuestionsList = [];
  final TextEditingController _QuestionsController = TextEditingController();
  int selectedQuestionsIndex = -1;

  void addQuestion() {
    String points = _QuestionsController.text;
    if (points.isNotEmpty) {
      setState(() {
        QuestionsList.add(
          DescriptionAndQuestionConvertor(
              pageNumber: QuestionPageNumber, data: points),
        );
        _QuestionsController.clear();
      });
    }
  }

  void editQuestion(int index) {
    setState(() {
      selectedQuestionsIndex = index;
      _QuestionsController.text = QuestionsList[index].data;
      QuestionPageNumber = QuestionsList[index].pageNumber;
    });
  }

  void saveQuestion() {
    String editedImage = _QuestionsController.text;
    if (editedImage.isNotEmpty && selectedQuestionsIndex != -1) {
      QuestionsList.removeAt(selectedQuestionsIndex);
      if (selectedQuestionsIndex == selectedQuestionsIndex) {
        selectedQuestionsIndex = -1;
        _QuestionsController.clear();
      }
      setState(() {
        QuestionsList.add(DescriptionAndQuestionConvertor(
            pageNumber: QuestionPageNumber, data: editedImage));
        _QuestionsController.clear();
        _QuestionsController.clear();
        selectedQuestionsIndex = -1;
        QuestionPageNumber = 0;
      });
    }
  }

  void deleteQuestion(int index) {
    setState(() {
      QuestionsList.removeAt(index);
      if (selectedQuestionsIndex == index) {
        selectedQuestionsIndex = -1;
        _QuestionsController.clear();
      }
    });
  }

  void moveQuestionUp(int index) {
    if (index > 0) {
      setState(() {
        DescriptionAndQuestionConvertor point = QuestionsList.removeAt(index);
        QuestionsList.insert(index - 1, point);
        if (selectedQuestionsIndex == index) {
          selectedQuestionsIndex--;
        }
      });
    }
  }

  void moveQuestionDown(int index) {
    if (index < QuestionsList.length - 1) {
      setState(() {
        DescriptionAndQuestionConvertor question =
        QuestionsList.removeAt(index);
        QuestionsList.insert(index + 1, question);
        if (selectedQuestionsIndex == index) {
          selectedQuestionsIndex++;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              backButton(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.mode == "units")
                        Padding(
                          padding: EdgeInsets.only(
                              left:   15, top:   8, bottom:   10),
                          child: Text(
                            "Type Selected : $unit",
                            style: creatorHeadingTextStyle,
                          ),
                        ),
                      if (widget.mode == "units")
                        SizedBox(
                          height:   30,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            // Display only top 5 items
                            itemBuilder: (context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding: EdgeInsets.only(left:   25),
                                  child: InkWell(
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: unit == "Unknown"
                                                ? Colors. black.withOpacity(0.6)
                                                : Colors. black.withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(  10)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:   3,
                                              horizontal:   8),
                                          child: Text(
                                            "Unknown",
                                            style: TextStyle(
                                                color: Colors. black,
                                                fontSize:   25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )),
                                    onTap: () {
                                      setState(() {
                                        unit = "Unknown";
                                      });
                                    },
                                  ),
                                );
                              } else {
                                return InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: unit == "Unit $index"
                                              ? Colors. black.withOpacity(0.6)
                                              : Colors. black.withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(  10)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:   3,
                                            horizontal:   8),
                                        child: Text(
                                          "Unit $index",
                                          style: TextStyle(
                                              color: Colors. black,
                                              fontSize:   25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                  onTap: () {
                                    setState(() {
                                      unit = "Unit $index";
                                    });
                                  },
                                );
                              }
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width:   3,
                            ),
                          ),
                        ),
                      TextFieldContainer(
                        child: TextFormField(
                          controller: HeadingController,
                          textInputAction: TextInputAction.next,
                          style: textFieldStyle(),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors. black54),
                            border: InputBorder.none,
                            hintText: 'Heading',
                          ),
                        ),
                        heading: "Heading",
                      ),
                      if (widget.mode == "more")
                        Padding(
                          padding: EdgeInsets.only(
                              left:   15, top:   8, bottom:   10),
                          child: Text(
                            "Type Selected : $unit",
                            style: creatorHeadingTextStyle,
                          ),
                        ),
                      if (widget.mode == "more")
                        SizedBox(
                          height:   30,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            // Display only top 5 items
                            itemBuilder: (context, int index) {
                              return InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: unit == list[index]
                                            ? Colors. black.withOpacity(0.6)
                                            : Colors. black.withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(  10)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:   3, horizontal:   8),
                                      child: Text(
                                        list[index],
                                        style: TextStyle(
                                            color: Colors. black,
                                            fontSize:   25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    unit = list[index];
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width:   3,
                            ),
                          ),
                        ),
                      if (unit != "more")
                        TextFieldContainer(
                          child: TextFormField(
                            controller: PDFUrlController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors. black54),
                              border: InputBorder.none,
                              hintText: 'Url',
                            ),
                          ),
                          heading: unit != "more"
                              ? "PDF Url"
                              : "Any Url (.img, .pdf, YT, .Web)",
                        ),
                      if (widget.mode == "units")
                        Padding(
                          padding: EdgeInsets.only(left:   15, top:   8),
                          child: Text(
                            "Description",
                            style: creatorHeadingTextStyle,
                          ),
                        ),
                      if (widget.mode == "units")
                        ListView.builder(
                          itemCount: DescriptionList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(DescriptionList[index].data),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                EdgeInsets.symmetric(horizontal:   16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                deleteDescription(index);
                              },
                              child: ListTile(
                                title: Text(
                                  DescriptionList[index].data,
                                  style: TextStyle(
                                      color: Colors. black, fontSize:   20),
                                ),
                                trailing: SingleChildScrollView(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          deleteDescription(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                        onPressed: () {
                                          editDescription(index);
                                          setState(() {
                                            isEdit = true;
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.move_up,
                                          size:   30,
                                          color: Colors.amber,
                                        ),
                                        onTap: () {
                                          moveDescriptionUp(index);
                                        },
                                        onDoubleTap: () {
                                          moveDescriptionDown(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  editDescription(index);
                                },
                              ),
                            );
                          },
                        ),
                      if (widget.mode == "units")
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left:   10,
                                  right:   10,
                                  top:   5,
                                  bottom:   5),
                              child: TextFieldContainer(
                                child: TextFormField(
                                  controller: _DescriptionController,
                                  style: textFieldStyle(),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Description Here',
                                    hintStyle: TextStyle(color: Colors. black54),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:   10,
                                        right:   10,
                                        top:   5,
                                        bottom:   5),
                                    child: TextFieldContainer(
                                      child: TextFormField(
                                        style: textFieldStyle(),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 1,
                                        onChanged: (value) {
                                          DescriptionPageNumber = int.parse(value);
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Page Number (Optional)',
                                          hintStyle:
                                          TextStyle(color: Colors. black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  child: !isEdit ? Text("Add") : Text("Save"),
                                  onPressed: () {
                                    !isEdit ? addDescription() : saveDescription();
                                    setState(() {
                                      isEdit = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      if (widget.mode == "units")
                        Padding(
                          padding: EdgeInsets.only(left:   15, top:   8),
                          child: Text(
                            "Question",
                            style: creatorHeadingTextStyle,
                          ),
                        ),
                      if (widget.mode == "units")
                        ListView.builder(
                          itemCount: QuestionsList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(QuestionsList[index].data),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                EdgeInsets.symmetric(horizontal:   16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                deleteQuestion(index);
                              },
                              child: ListTile(
                                title: Text(
                                  QuestionsList[index].data,
                                  style: TextStyle(
                                      color: Colors. black, fontSize:   20),
                                ),
                                trailing: SingleChildScrollView(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          deleteQuestion(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                        onPressed: () {
                                          editQuestion(index);
                                          setState(() {
                                            isEdit = true;
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.move_up,
                                          size:   30,
                                          color: Colors.amber,
                                        ),
                                        onTap: () {
                                          moveQuestionUp(index);
                                        },
                                        onDoubleTap: () {
                                          moveQuestionDown(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  editQuestion(index);
                                },
                              ),
                            );
                          },
                        ),
                      if (widget.mode == "units")
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left:   10,
                                  right:   10,
                                  top:   5,
                                  bottom:   5),
                              child: TextFieldContainer(
                                  child: TextFormField(
                                    controller: _QuestionsController,
                                    style: textFieldStyle(),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Question Here',
                                      hintStyle: TextStyle(color: Colors. black54),
                                    ),
                                  )),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:   10,
                                        right:   10,
                                        top:   5,
                                        bottom:   5),
                                    child: TextFieldContainer(
                                        child: TextFormField(
                                          style: textFieldStyle(),
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 1,
                                          onChanged: (value) {},
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter Question Here',
                                            hintStyle: TextStyle(color: Colors. black54),
                                          ),
                                        )),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors. black12,
                                      border: Border.all(color: Colors. black),
                                      borderRadius:
                                      BorderRadius.circular(  14),
                                    ),
                                    child: Icon(
                                      !isEdit ? Icons.add : Icons.save,
                                      size:   45,
                                      color: Colors. black,
                                    ),
                                  ),
                                  onTap: () {
                                    !isEdit ? addQuestion() : saveQuestion();
                                    setState(() {
                                      isEdit = false;
                                    });
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      if (widget.mode == "more")
                        Padding(
                          padding: EdgeInsets.only(left:   15, top:   8),
                          child: Text(
                            "Description",
                            style: creatorHeadingTextStyle,
                          ),
                        ),
                      if (widget.mode == "more")
                        ListView.builder(
                          itemCount: NormalDescriptionList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(NormalDescriptionList[index]),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding:
                                EdgeInsets.symmetric(horizontal:   16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                deleteNormalDescription(index);
                              },
                              child: ListTile(
                                title: Text(
                                  NormalDescriptionList[index],
                                  style: TextStyle(
                                      color: Colors. black, fontSize:   20),
                                ),
                                trailing: SingleChildScrollView(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          deleteNormalDescription(index);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.greenAccent,
                                        ),
                                        onPressed: () {
                                          editNormalDescription(index);
                                          setState(() {
                                            isEdit = true;
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.move_up,
                                          size:   30,
                                          color: Colors.amber,
                                        ),
                                        onTap: () {
                                          moveNormalDescriptionUp(index);
                                        },
                                        onDoubleTap: () {
                                          moveNormalDescriptionDown(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  editNormalDescription(index);
                                },
                              ),
                            );
                          },
                        ),
                      if (widget.mode == "more")
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left:   10,
                                    right:   10,
                                    top:   5,
                                    bottom:   5),
                                child: TextFieldContainer(
                                    child: TextFormField(
                                      controller: _NormalDescriptionController,
                                      style: textFieldStyle(),
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Description Here',
                                        hintStyle: TextStyle(color: Colors. black54),
                                      ),
                                    )),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors. black12,
                                  border: Border.all(color: Colors. black),
                                  borderRadius: BorderRadius.circular(  14),
                                ),
                                child: Icon(
                                  !isEdit ? Icons.add : Icons.save,
                                  size:   45,
                                  color: Colors. black,
                                ),
                              ),
                              onTap: () {
                                !isEdit ? addNormalDescription() : saveNormalDescription();
                                setState(() {
                                  isEdit = false;
                                });
                              },
                            )
                          ],
                        ),
                      if (widget.mode == "textBook")
                        TextFieldContainer(
                          child: TextFormField(
                            controller: AuthorController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors. black54),
                              border: InputBorder.none,
                              hintText: 'Author',
                            ),
                          ),
                          heading: "Author",
                        ),
                      if (widget.mode == "textBook")
                        TextFieldContainer(
                          child: TextFormField(
                            controller: EditionController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors. black54),
                              border: InputBorder.none,
                              hintText: 'Edition',
                            ),
                          ),
                          heading: "Edition",
                        ),
                      SizedBox(
                        height:   10,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Back"),
                          ),
                          SizedBox(
                            width:   10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.greenAccent),
                              ),
                              onPressed: (){},
                              // onPressed: () async {
                              //   if (widget.mode == "units") {
                              //     if (widget.unit == null) {
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'units': FieldValue.arrayUnion([
                              //           FileUploader(
                              //             id: getID(),
                              //             Heading: HeadingController.text.trim(),
                              //             Description: DescriptionList,
                              //             Link: PDFUrlController.text,
                              //             Unit: unit,
                              //             Size: '',
                              //             Question: QuestionsList,
                              //           ).toJson(),
                              //         ]),
                              //       });
                              //     } else {
                              //       List<UnitConvertor> updatedUnits = List.from(
                              //         widget.subject.units
                              //             .where(
                              //                 (unit) => unit.id != widget.unit!.id)
                              //             .toList(),
                              //       );
                              //       try {
                              //         updatedUnits.add(UnitConvertor(
                              //           id: widget.unit!.id,
                              //           Heading: HeadingController.text.trim(),
                              //           Description: DescriptionList,
                              //           Link: PDFUrlController.text,
                              //           Unit: unit,
                              //           Size: widget.unit!.Size,
                              //           Question: QuestionsList,
                              //         ));
                              //       } catch (e) {
                              //         print("Error updating units: $e");
                              //       }
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'units': updatedUnits
                              //             .map((unit) => unit.toJson())
                              //             .toList(),
                              //       });
                              //     }
                              //   } else if (widget.mode == "textBook") {
                              //     if (widget.textBook == null) {
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'textBooks': FieldValue.arrayUnion([
                              //           TextBookConvertor(
                              //             id: getID(),
                              //             Heading: HeadingController.text.trim(),
                              //             Link: PDFUrlController.text,
                              //             Size: '',
                              //             Author: AuthorController.text.trim(),
                              //             Edition: EditionController.text.trim(),
                              //           ).toJson(),
                              //         ]),
                              //       });
                              //     } else {
                              //       List<TextBookConvertor> updatedTextBook =
                              //           List.from(
                              //         widget.subject.moreInfos
                              //             .where((unit) =>
                              //                 unit.id != widget.moreInfo!.id)
                              //             .toList(),
                              //       );
                              //
                              //       try {
                              //         updatedTextBook.add(TextBookConvertor(
                              //           id: widget.textBook!.id,
                              //           Heading: HeadingController.text.trim(),
                              //           Link: PDFUrlController.text,
                              //           Size: widget.textBook!.Size,
                              //           Author: AuthorController.text,
                              //           Edition: EditionController.text,
                              //         ));
                              //       } catch (e) {
                              //         print("Error updating units: $e");
                              //       }
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'textBooks': updatedTextBook
                              //             .map((unit) => unit.toJson())
                              //             .toList(),
                              //       });
                              //     }
                              //   } else {
                              //     if (widget.moreInfo == null) {
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'moreInfos': FieldValue.arrayUnion([
                              //           MoreInfoConvertor(
                              //             id: getID(),
                              //             Heading: HeadingController.text.trim(),
                              //             Link: PDFUrlController.text,
                              //             Description: NormalDescriptionList,
                              //             Type: unit,
                              //           ).toJson(),
                              //         ]),
                              //       });
                              //     } else {
                              //       List<MoreInfoConvertor> updatedMore = List.from(
                              //         widget.subject.moreInfos
                              //             .where((unit) =>
                              //                 unit.id != widget.moreInfo!.id)
                              //             .toList(),
                              //       );
                              //
                              //       try {
                              //         updatedMore.add(MoreInfoConvertor(
                              //           id: widget.moreInfo!.id,
                              //           Heading: HeadingController.text.trim(),
                              //           Description: NormalDescriptionList,
                              //           Link: PDFUrlController.text,
                              //           Type: unit,
                              //         ));
                              //       } catch (e) {
                              //         print("Error updating units: $e");
                              //       }
                              //       await _firestore
                              //           .collection('StudyMaterials')
                              //           .doc(widget.branch)
                              //           .collection("Subjects")
                              //           .doc(widget.subjectId)
                              //           .update({
                              //         'moreInfos': updatedMore
                              //             .map((unit) => unit.toJson())
                              //             .toList(),
                              //       });
                              //     }
                              //   }
                              //
                              //   Navigator.pop(context);
                              //   Navigator.pop(context);
                              // },
                              child: Text(widget.unit == null ||
                                  widget.textBook == null ||
                                  widget.moreInfo == null
                                  ? "Create"
                                  : "Update")),
                          SizedBox(
                            width:   20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

