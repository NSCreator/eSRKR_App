import 'package:srkr_study_app/settings/settings.dart';
import '../notification.dart';
import '../uploader.dart';

class SubjectConverter {
  final String id;
  final HeadingConvertor heading;
  final List<OldPapersConvertor> oldPapers;
  final String description;
  final List<FileUploader> units;
  final List<FileUploader> textBooks;
  final List<MoreInfoConvertor> moreInfos;

  final CreatedByAndPermissionsConvertor createdByAndPermissions;

  SubjectConverter({
    required this.id,
    required this.heading,
    required this.oldPapers,
    required this.units,
    required this.description,
    required this.textBooks,
    required this.moreInfos,
    required this.createdByAndPermissions,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "heading": heading.toJson(),
    "units": units.map((unit) => unit.toJson()).toList(),
    "oldPapers": oldPapers.map((oldPaper) => oldPaper.toJson()).toList(),
    "textBooks": textBooks.map((textBook) => textBook.toJson()).toList(),
    "moreInfos": moreInfos.map((info) => info.toJson()).toList(),
    "createdByAndPermissions": createdByAndPermissions.toJson(),
  };


  static SubjectConverter fromJson(Map<String, dynamic> json) =>
      SubjectConverter(
        id: json['id'] ?? "",
        heading: HeadingConvertor.fromJson(json['heading'] ?? {}),
        description: json['description'] ?? "",
        units: (json['units'] as List<dynamic>)
            .map((unit) => FileUploader.fromJson(unit))
            .toList(),
        oldPapers: (json['oldPapers'] as List<dynamic>)
            .map((oldPaper) => OldPapersConvertor.fromJson(oldPaper))
            .toList(),

        textBooks: (json['textBooks'] as List<dynamic>)
            .map((textBook) => FileUploader.fromJson(textBook))
            .toList(),
        moreInfos: (json['moreInfos'] as List<dynamic>)
            .map((info) => MoreInfoConvertor.fromJson(info))
            .toList(),
        createdByAndPermissions: CreatedByAndPermissionsConvertor.fromJson(
            json['createdByAndPermissions'] ?? {}),
      );

  static List<SubjectConverter> fromMapList(List<dynamic> list) {
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


  CreatedByAndPermissionsConvertor({
    required this.id,
    required this.isDownloadable,
    required this.EditAccess,

  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "EditAccess": EditAccess,

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

      );

  static List<CreatedByAndPermissionsConvertor> fromMapList(
      List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
Future CreateSubject({
  required String id,
  required bool isSub,
  required bool isUpdate,
  required String Branch,
  required HeadingConvertor Heading,
  required String Description,
  required List<MoreInfoConvertor> MoreInfos,
  required List<OldPapersConvertor> OldPapers,
  required List<FileUploader> TextBooks,
  required List<FileUploader> Units,
  required CreatedByAndPermissionsConvertor CreatedByAndPermissions,
}) async {
  final docTrip = firestore
      .collection('StudyMaterials')
      .doc(Branch)
      .collection(isSub ? "Subjects" : "LabSubjects")
      .doc(id);
  final tripData = SubjectConverter(
    id: id,
    heading: Heading,
    units: Units,
    description: Description,
    textBooks: TextBooks,
    moreInfos: MoreInfos,
    createdByAndPermissions: CreatedByAndPermissions,
    oldPapers: OldPapers,
  );

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
  messageToOwner("${jsonData}");
}
