import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srkr_study_app/functions.dart';

class CreatePollPage extends StatefulWidget {
  const CreatePollPage({Key? key}) : super(key: key);

  @override
  _CreatePollPageState createState() => _CreatePollPageState();
}

class _CreatePollPageState extends State<CreatePollPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize two option controllers by default
    _optionControllers.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
  }

  Future<void> _createPoll() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed to create the poll
      try {
        // Create a list to store options
        List<Map<String, dynamic>> options = [];
        for (int i = 0; i < _optionControllers.length; i++) {
          String optionTitle = _optionControllers[i].text;
          // Skip empty option titles
          if (optionTitle.isNotEmpty) {
            options.add({
              'id': i + 1,
              'title': optionTitle,
              'votes': 0,
            });
          }
        }

        // Add the poll data to Firestore
        String id = getID();
        await FirebaseFirestore.instance.collection('polls').doc(id).set({
          'id': id,
          'options': options,
          'question': _questionController.text,
          'end_date': DateTime.now().add(Duration(days: 7)), // Example: End date is 7 days from now
          'created_time': DateTime.now(),
          'created_by': fullUserId(),
          "votedIds": [],
        });

        // Navigate back to previous screen or show success message
        Navigator.pop(context);
      } catch (e) {
        // Handle errors, such as Firestore write errors
        print('Error creating poll: $e');
        // You can show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Poll'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Poll Question'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListView.builder(
                itemCount: _optionControllers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter option ${index + 1}';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add a new option controller when the button is pressed
                  setState(() {
                    _optionControllers.add(TextEditingController());
                  });
                },
                child: Text('Add Option'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPoll,
                child: Text('Create Poll'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
