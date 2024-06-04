import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';
import 'package:srkr_study_app/notification.dart';

import 'TextField.dart';
import 'auth_page.dart';

class MyApp000 extends StatefulWidget {
  @override
  State<MyApp000> createState() => _MyApp000State();
}

class _MyApp000State extends State<MyApp000> {
  final _formKey = GlobalKey<FormState>();

  final feedbackController = TextEditingController();

  Future<void> _saveFeedback() async {
    try {
      String id = getID();
      await FirebaseFirestore.instance.collection('feedback').doc(id).set({
        'userId': fullUserId(),
        'feedback': feedbackController.text,
        'id': id,
      });
      messageToOwner(feedbackController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully')),
      );
      feedbackController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback')),
      );
    }
  }

  @override
  void dispose() {
    feedbackController.dispose();
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
              Row(
                children: [
                  backButton(),
                  Heading(heading: "Feedback Form"),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFieldContainer(
                      child: TextFormField(
                        controller: feedbackController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Feedback',
                            hintStyle: textFieldHintStyle()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                        maxLines: null,
                      ),heading: "Give Your FeedBack",),

                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if(isAnonymousUser()){
                          showToastText("Please log in with your college ID.");
                          return ;
                        }
                        if (_formKey.currentState!.validate()) {
                          // Save feedback to Firestore
                          _saveFeedback();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
              if(isOwner())Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(color: Colors.white54,),
              ),

              if(isOwner())StreamBuilder<QuerySnapshot>(
                stream:
                FirebaseFirestore.instance.collection('feedback').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<FeedbackItem> feedbackItems = [];
                  snapshot.data!.docs.forEach((doc) {
                    String feedback = doc['feedback'];
                    String feedbackUserId = doc['userId'];
                    String timestamp = doc['id'];

                    feedbackItems.add(FeedbackItem(
                        feedback: feedback,
                        userId: feedbackUserId,
                        id: timestamp

                    ));
                  });

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Heading(heading: "Submitted Forms -> ${feedbackItems.length}"),
                        ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: feedbackItems,
                        ),
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

class FeedbackItem extends StatelessWidget {
  final String feedback;
  final String id;

  final String userId;


  FeedbackItem({
    required this.feedback,
    required this.id,
    required this.userId,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.black.withOpacity(0.01),
      child: ListTile(

        title: Text(feedback,style: TextStyle(fontSize: 20),),
        subtitle: Text(userId,style: TextStyle(fontSize: 12),),
        trailing: (userId == fullUserId())||(isOwner())
            ? IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteFeedback(id);
                },
              )
            : null,
      ),
    );
  }

  Future<void> _deleteFeedback(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(docId)
          .delete();
    } catch (error) {
      showToastText('Failed to delete feedback');
    }
  }
}
