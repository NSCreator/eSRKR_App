import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/SubPages.dart';
import 'package:srkr_study_app/homePage/settings.dart';

import 'homePage/HomePage.dart';
import 'TextField.dart';
import 'functions.dart';
import 'notification.dart';

class SubjectCreator extends StatefulWidget {
  subjectConvertor? data;
  String branch;
  bool isSub;


  SubjectCreator({
    required this.branch,
    this.data,

    this.isSub = true,
  });

  @override
  State<SubjectCreator> createState() => _SubjectCreatorState();
}

class _SubjectCreatorState extends State<SubjectCreator> {
  List<UnitConvertor> Unit = [];
  List<TextBookConvertor> TextBooks = [];
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
    Unit = widget.data!.units;
    TextBooks = widget.data!.textBooks;
    MoreInfos = widget.data!.moreInfos;
    EditAccess = widget.data!.createdByAndPermissions.EditAccess;
    BranchAccess = widget.data!.createdByAndPermissions.BranchAccess;
    descriptionList = widget.data!.oldPapers;
    Regulation = widget.data!.regulation;
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
                  text: widget.isSub ? "Subject Editor" : "Lab Subject Editor",
                  child: SizedBox(
                    width:   45,
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFieldContainer(
                      child: TextFormField(
                        controller: ShortHeadingController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                            color: Colors. black, fontSize:   20),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors. black54)),
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
                        style: TextStyle(
                            color: Colors. black, fontSize:   20),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Colors. black54)),
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
                  style: TextStyle(
                      color: Colors. black, fontSize:   20),

                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Description or Full name',
                      hintStyle: TextStyle(color: Colors. black54)),
                ),
                heading: "Description",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:   10.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(  8),
                          color: Colors.  black26,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:   5,
                              horizontal:   10),
                          child: Text(
                            "Change Regulation",
                            style: TextStyle(
                                color: Colors. black,
                                fontSize:   22),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              elevation: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.  black87,
                                    borderRadius: BorderRadius.circular(
                                          30)),
                                child: StreamBuilder<List<RegulationConvertor>>(
                                    stream: readRegulation(widget.branch),
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
                                            return const Center(
                                                child: Text(
                                                    'Error with Regulation Data or\n Check Internet Connection'));
                                          } else {
                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: user!.length,
                                              itemBuilder:
                                                  (context, int index) {
                                                final SubjectsData =
                                                    user[index];
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                 
                                                                    5.0),
                                                    child: InkWell(
                                                      child: Text(
                                                        SubjectsData.id
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                 
                                                                    20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          Regulation.add(
                                                              SubjectsData.id
                                                                  .toUpperCase());
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                      }
                                    }),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Regulation.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            Regulation[index],
                            style:
                                TextStyle(color: Colors.  black54, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.  black87,
                            ),
                            onPressed: () {
                              deleteRegulation(index);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 8),
                child: Text(
                  "Old Papers",
                  style: creatorHeadingTextStyle,
                ),
              ),
              ListView.builder(
                itemCount: descriptionList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(descriptionList[index].heading),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        descriptionList[index].heading,
                        style: TextStyle(color: Colors. black, fontSize: 20),
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
                                size: 30,
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
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: TextFieldContainer(
                      child: TextFormField(
                        controller: _headingController,
                        style: textFieldStyle(),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Old Papers Here',
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
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: TextFieldContainer(
                            child: TextFormField(
                              controller: _pdfLinkController,
                              style: textFieldStyle(),
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Link',
                                hintStyle: TextStyle(color: Colors. black54),
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors. black.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Subjects Accessing ( Optional )",
                      style: TextStyle(color: Colors.  black87, fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: Text(
                        "Created By ${fullUserId()}",
                        style: TextStyle(color: Colors. black, fontSize: 18),
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
                              style: TextStyle(
                                  color: Colors. black,
                                  fontSize:   20),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter gmail id',
                                hintStyle: TextStyle(color: Colors. black54),
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
                                TextStyle(color: Colors.  black54, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.  black87,
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
                              style: TextStyle(
                                  color: Colors. black,
                                  fontSize:   20),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Branch (ece or ECE)',
                                hintStyle: TextStyle(color: Colors. black54),
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
                                TextStyle(color: Colors.  black54, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.  black87,
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
                                color: Colors. black,
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
                      backgroundColor: Colors.  black87,
                    ),
                    child: Text("Back"),
                  ),
                  SizedBox(
                    width:   10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        CreateSubject(
                            isUpdate: widget.data != null,
                            isSub: widget.isSub,
                            id: widget.data != null ? widget.data!.id : getID(),
                            Branch: widget.branch,
                            Heading: HeadingConvertor(
                                full: FullHeadingController.text,
                                short: ShortHeadingController.text),
                            Description: DescriptionController.text,
                            MoreInfos: MoreInfos,
                            TextBooks: TextBooks,
                            Units: Unit,
                            CreatedByAndPermissions:
                                CreatedByAndPermissionsConvertor(
                                    id: fullUserId(),
                                    EditAccess: EditAccess,
                                    BranchAccess: BranchAccess,
                                    isDownloadable: _switch1Value),
                            Regulation: Regulation,
                            OldPapers: descriptionList, QAFromChatGPT: []);
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
                    width:   20,
                  )
                ],
              ),
              SizedBox(
                height:   20,
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

Future CreateSubject({
  required String id,
  required List<String> Regulation,
  required bool isSub,
  required bool isUpdate,
  required String Branch,
  required HeadingConvertor Heading,
  required String Description,
  required List<MoreInfoConvertor> MoreInfos,
  required List<OldPapersConvertor> OldPapers,
  required List<TextBookConvertor> TextBooks,
  required List<UnitConvertor> Units,
  required List<questionsFromChatGPTConvertor> QAFromChatGPT,
  required CreatedByAndPermissionsConvertor CreatedByAndPermissions,
}) async {
  final docTrip = FirebaseFirestore.instance
      .collection('StudyMaterials')
      .doc(Branch)
      .collection(isSub ? "Subjects" : "LabSubjects")
      .doc(id);
  final tripData = subjectConvertor(
    id: id,
    heading: Heading,
    regulation: Regulation,
    units: Units,
    description: Description,
    textBooks: TextBooks,
    moreInfos: MoreInfos,
    createdByAndPermissions: CreatedByAndPermissions,
    oldPapers: OldPapers, QAFromChatGPT: QAFromChatGPT,
  );

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
  messageToOwner("${jsonData}");
}

class subjectConvertor {
  final String id;
  final HeadingConvertor heading;
  final List<OldPapersConvertor> oldPapers;
  final List<String> regulation;
  final String description;
  final List<UnitConvertor> units;
  final List<TextBookConvertor> textBooks;
  final List<MoreInfoConvertor> moreInfos;
  final List<questionsFromChatGPTConvertor> QAFromChatGPT;
  final CreatedByAndPermissionsConvertor createdByAndPermissions;

  subjectConvertor({
    required this.id,
    required this.heading,
    required this.regulation,
    required this.oldPapers,
    required this.units,
    required this.QAFromChatGPT,
    required this.description,
    required this.textBooks,
    required this.moreInfos,
    required this.createdByAndPermissions,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "regulation": regulation,
        "heading": heading.toJson(),
        "units": units.map((unit) => unit.toJson()).toList(),
        "QAFromChatGPT": QAFromChatGPT.map((unit) => unit.toJson()).toList(),
        "oldPapers": oldPapers.map((oldPaper) => oldPaper.toJson()).toList(),
        "textBooks": textBooks.map((textBook) => textBook.toJson()).toList(),
        "moreInfos": moreInfos.map((info) => info.toJson()).toList(),
        "createdByAndPermissions": createdByAndPermissions.toJson(),
      };
  int getSubjectCountWithQuestions() {
    return QAFromChatGPT.isNotEmpty ? 1 : 0;
  }

  static subjectConvertor fromJson(Map<String, dynamic> json) =>
      subjectConvertor(
        id: json['id'] ?? "",
        regulation: List<String>.from(json['regulation'] ?? []),
        heading: HeadingConvertor.fromJson(json['heading'] ?? {}),
        description: json['description'] ?? "",
        units: UnitConvertor.fromMapList(json['units'] ?? []),
        oldPapers: OldPapersConvertor.fromMapList(json['oldPapers'] ?? []),
        QAFromChatGPT: questionsFromChatGPTConvertor.fromMapList(json['QAFromChatGPT'] ?? []),
        textBooks: TextBookConvertor.fromMapList(json['textBooks'] ?? []),
        moreInfos: MoreInfoConvertor.fromMapList(json['moreInfos'] ?? []),
        createdByAndPermissions: CreatedByAndPermissionsConvertor.fromJson(
            json['createdByAndPermissions'] ?? {}),
      );

  static List<subjectConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class HeadingConvertor {
  final String short;
  final String full;

  HeadingConvertor({
    required this.full,
    required this.short,
  });

  Map<String, dynamic> toJson() => {"full": full, "short": short};

  static HeadingConvertor fromJson(Map<String, dynamic> json) =>
      HeadingConvertor(
        short: json['short'] ?? "",
        full: json["full"] ?? "",
      );

  static List<HeadingConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class OldPapersConvertor {
  final String heading;
  final String pdfLink;

  OldPapersConvertor({
    required this.pdfLink,
    required this.heading,
  });

  Map<String, dynamic> toJson() => {"pdfLink": pdfLink, "heading": heading};

  static OldPapersConvertor fromJson(Map<String, dynamic> json) =>
      OldPapersConvertor(
        heading: json['heading'] ?? "",
        pdfLink: json["pdfLink"] ?? "",
      );

  static List<OldPapersConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class UnitConvertor {
  final String Heading, id, Unit, Size, Link;
  final List<DescriptionAndQuestionConvertor> Description;
  final List<DescriptionAndQuestionConvertor> Question;

  UnitConvertor({
    required this.Heading,
    required this.Description,
    required this.Question,
    required this.id,
    required this.Link,
    required this.Unit,
    required this.Size

  });

  Map<String, dynamic> toJson() => {
        "Heading": Heading,
        "id": id,
        "Unit": Unit,
        'Size': Size,
        "Description": Description.map((d) => d.toJson()).toList(),
        "Link": Link,
        "Question": Question.map((q) => q.toJson()).toList(),
      };

  static UnitConvertor fromJson(Map<String, dynamic> json) => UnitConvertor(
        id: json['id'] ?? "",
        Description: DescriptionAndQuestionConvertor.fromMapList(
            json['Description'] ?? []),
        Question:
            DescriptionAndQuestionConvertor.fromMapList(json['Question'] ?? []),
        Heading: json["Heading"] ?? "",
        Link: json["Link"] ?? "",
        Size: json["Size"] ?? "",
        Unit: json["Unit"] ?? "",
      );

  static List<UnitConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class DescriptionAndQuestionConvertor {
  late final String data;
  late final int pageNumber;

  DescriptionAndQuestionConvertor({
    required this.pageNumber,
    required this.data,
  });

  Map<String, dynamic> toJson() => {"pageNumber": pageNumber, "data": data};

  static DescriptionAndQuestionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionAndQuestionConvertor(
        data: json['data'] ?? "",
        pageNumber: json["pageNumber"] ?? 0,
      );

  static List<DescriptionAndQuestionConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class TextBookConvertor {
  final String Heading, id, Link, Size, Author, Edition;

  TextBookConvertor({
    required this.Heading,
    required this.id,
    required this.Link,
  required this.Size ,
    required this.Author,
    required this.Edition,
  });

  Map<String, dynamic> toJson() => {
        "Heading": Heading,
        "id": id,
        "Link": Link,
        'Size': Size,
        'Author': Author,
        'Edition': Edition,
      };

  static TextBookConvertor fromJson(Map<String, dynamic> json) =>
      TextBookConvertor(
        id: json['id'] ?? "",
        Heading: json["Heading"] ?? "",
        Size: json["Size"] ?? '',
        Link: json["Link"] ?? "",
        Author: json["Author"] ?? "",
        Edition: json["Edition"] ?? "",
      );

  static List<TextBookConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class MoreInfoConvertor {
  final String Heading, id, Link, Type;
  final List<String> Description;

  MoreInfoConvertor({
    required this.Heading,
    required this.id,
    required this.Link,
    required this.Description,
    required this.Type,
  });

  Map<String, dynamic> toJson() => {
        "Heading": Heading,
        "id": id,
        "Link": Link,
        'Type': Type,
        "Description": Description
      };

  static MoreInfoConvertor fromJson(
          Map<String, dynamic> json) =>
      MoreInfoConvertor(
          id: json['id'],
          Heading: json["Heading"] ?? "",
          Description:
              (json["description"] as List<dynamic>?)?.cast<String>() ?? [],
          Type: json["Type"] ?? "",
          Link: json["Link"] ?? "");

  static List<MoreInfoConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class CreatedByAndPermissionsConvertor {
  final String id;
  final bool isDownloadable;
  final List<String> EditAccess;
  final List<String> BranchAccess;

  CreatedByAndPermissionsConvertor({
    required this.id,
    required this.isDownloadable,
    required this.EditAccess,
    required this.BranchAccess,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "EditAccess": EditAccess,
        "BranchAccess": BranchAccess,
        "isDownloadable": isDownloadable
      };

  static CreatedByAndPermissionsConvertor fromJson(Map<String, dynamic> json) =>
      CreatedByAndPermissionsConvertor(
        id: json['id'] ?? "",
        isDownloadable: json['isDownloadable'] ?? false,
        EditAccess: (json['EditAccess'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        BranchAccess: (json['BranchAccess'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  static List<CreatedByAndPermissionsConvertor> fromMapList(
      List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

Future<BranchStudyMaterialsConvertor?> getBranchStudyMaterials(
    String branch, bool isLoading) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final studyMaterialsJson = await prefs.getString("studyMaterials");

  if (studyMaterialsJson == null || isLoading) {

    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("StudyMaterials")
          .doc(branch)
          .get();
      if (documentSnapshot.exists) {

        var documentData = documentSnapshot.data();
        try {
          final subjectsQuery =
              await documentSnapshot.reference.collection("Subjects").get();
          final labSubjectsQuery =
              await documentSnapshot.reference.collection("LabSubjects").get();

          final subjects = await subjectsQuery.docs
              .map((doc) => subjectConvertor.fromJson(doc.data()))
              .toList();
          final labSubjects = await labSubjectsQuery.docs
              .map((doc) => subjectConvertor.fromJson(doc.data()))
              .toList();
          final regSylMp = await (documentData!["RegSylMP"] as List<dynamic>?)
                  ?.map((item) => RegSylMPConvertor.fromJson(item))
                  .toList() ??
              [];
          final regAndTT =
              await (documentData["RegulationAndTimeTable"] as List<dynamic>?)
                      ?.map((item) => RegTimeTableConvertor.fromJson(item))
                      .toList() ??
                  [];
          final data = await BranchStudyMaterialsConvertor(
            subjects: subjects,
            labSubjects: labSubjects,
            regSylMP: regSylMp,
            regulationAndTimeTable: regAndTT,
          );

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
  }
  else {
    return await BranchStudyMaterialsConvertor.fromJson(
        json.decode(studyMaterialsJson));
  }
}

class BranchStudyMaterialsConvertor {
  List<subjectConvertor> subjects;
  List<subjectConvertor> labSubjects;
  List<RegSylMPConvertor> regSylMP;
  List<RegTimeTableConvertor> regulationAndTimeTable;

  BranchStudyMaterialsConvertor({
    required this.subjects,
    required this.labSubjects,
    required this.regSylMP,
    required this.regulationAndTimeTable,
  });

  Map<String, dynamic> toJson() => {
        "Subjects": subjects.map((subject) => subject.toJson()).toList(),
        "RegulationAndTimeTable": regulationAndTimeTable
            .map((regulationAndTimeTable) => regulationAndTimeTable.toJson())
            .toList(),
        "RegSylMP": regSylMP.map((regSylMP) => regSylMP.toJson()).toList(),
        "LabSubjects":
            labSubjects.map((labSubject) => labSubject.toJson()).toList(),
      };

  static BranchStudyMaterialsConvertor fromJson(Map<String, dynamic> json) =>
      BranchStudyMaterialsConvertor(
        subjects: (json['Subjects'] as List<dynamic>?)
                ?.map((item) => subjectConvertor.fromJson(item))
                .toList() ??
            [],
        regulationAndTimeTable:
            (json['RegulationAndTimeTable'] as List<dynamic>?)
                    ?.map((item) => RegTimeTableConvertor.fromJson(item))
                    .toList() ??
                [],
        regSylMP: (json['RegSylMP'] as List<dynamic>?)
                ?.map((item) => RegSylMPConvertor.fromJson(item))
                .toList() ??
            [],
        labSubjects: (json['LabSubjects'] as List<dynamic>?)
                ?.map((item) => subjectConvertor.fromJson(item))
                .toList() ??
            [],
      );

  static List<BranchStudyMaterialsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
