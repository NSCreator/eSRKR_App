import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:srkr_study_app/auth_page.dart';
import 'package:srkr_study_app/functions.dart';
import 'package:srkr_study_app/settings/settings.dart';

import '../TextField.dart';

class EditProfilePage extends StatefulWidget {
  Function(bool) onChange;
  EditProfilePage({required this.onChange});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _nameController.text = _user!.displayName!.split(";").first ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!mounted) return; // Check if widget is still mounted

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent users from dismissing the dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(), // Circular loading indicator
        );
      },
    );

    try {
      String branch = getBranch(fullUserId());
      await _user!.updateDisplayName(_nameController.text.split(";").first + ";" + branch);

      if (!mounted) return; // Check again in case the widget got unmounted during async operation
      Navigator.of(context).pop(); // Dismiss the loading indicator

      widget.onChange(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      if (!mounted) return; // Check if mounted before showing SnackBar
      Navigator.of(context).pop(); // Dismiss the loading indicator

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            backButton(),
            Heading(heading: "Edit Profile"),
            TextFieldContainer(
                child: TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  style: textFieldStyle(),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name',
                      hintStyle: textFieldHintStyle()),

                ),heading: "Profile Name",),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                     await _updateProfile();
                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
