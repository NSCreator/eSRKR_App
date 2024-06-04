import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/notification.dart';
import 'package:srkr_study_app/uploader.dart';

import 'TextField.dart';
import 'auth_page.dart';

class SendMeFiles extends StatefulWidget {
  @override
  _SendMeFilesState createState() => _SendMeFilesState();
}

class _SendMeFilesState extends State<SendMeFiles> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();
  List<FileUploader> files = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Upload Files ( Help Us )",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.white54)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                heading: "Please Enter Your Name",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Text(
                  "Email : ${fullUserId()}",
                  style: TextStyle(fontSize: 20,color: Colors.white70),
                ),
              ),
              Center(
                child: Column(

                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Heading(
                      heading: "Upload Files",
                      padding: EdgeInsets.zero,
                    ),
                    Uploader(
                      type: FileType.any,
                      token: sub_esrkr,
                      path: "Send Me Files",
                      getIVF: (data) {
                        setState(() {
                          files.addAll(data);
                        });
                      },
                      allowMultiple: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              TextFieldContainer(
                child: TextFormField(
                  controller: _feedbackController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                      labelStyle: TextStyle(color: Colors.white54),
                      labelText:
                          'Details Like (Subject Name or PDFs Names etc.,)',
                      hintStyle: TextStyle(color: Colors.white54)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter File Note';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                heading: "Files Details",
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(isAnonymousUser()){
                          showToastText("Please log in with your college ID.");
                          return ;
                        }
                        if (_formKey.currentState!.validate()) {
                          await sendMessage(
                              "Name : ${_nameController.text}\nEmail : ${fullUserId()}\nTotal Files : ${files.length}\nNote : ${_feedbackController.text}");
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Uploaded Files Submitted'),
                                content: Text('Thank you for your support!'),
                                actions: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      messageToOwner("New Files are Uploaded");
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
                child: Column(
                  children: [
                    Text(
                      "Please Upload If You Have Question Papers, Images, PDFs, Documents, And All Types Of Files For The eSRKR App And For Your Juniors.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    Center(
                      child: Text(
                        " Thank You. ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
