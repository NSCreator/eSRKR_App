import 'dart:async';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TextField.dart';
import 'main.dart';
import 'notification.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController_X = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[400],
          image: DecorationImage(
              image: NetworkImage(
                  "https://firebasestorage.googleapis.com/v0/b/e-srkr.appspot.com/o/auth_page%2F315537679.jpg?alt=media&token=e2e3c4f9-a19f-4593-b193-533196b48b0b"),
              fit: BoxFit.fill)),
      child: Container(
        height: double.infinity,
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "e-SRKR ",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "( ECE )",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              //email textfield
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              //password
              SizedBox(
                height: 5,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Note : LogIn with Your RegisterNumber@srkrec.ac.in",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ),
              //sign in button
              SizedBox(
                height: 10,
              ),

              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                onTap: signIn,
              ),

              SizedBox(
                height: 20,
              ),
              InkWell(
                child: Text(
                  "Forgot Password? ( Owner )",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Ends with @gmail.com can Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextFormField(
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                      ),
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? "Enter a valid Email"
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  resetPassword();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text('Reset'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  "Forgot Password? ( Student )",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Ends with @srkrec.ac.in can Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextFormField(
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Your College Gmail Id',
                                      ),
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? "Enter a valid Email"
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Note : In Few Days Your Account Has Been Deleted and Create New One.",
                                  style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (emailController.text
                                          .trim()
                                          .split("@")
                                          .last
                                          .toLowerCase() ==
                                      "srkrec.ac.in") {
                                    hi(emailController.text.trim());
                                    emailController.clear();
                                    showToast("Message Has Been Send.");
                                    Navigator.pop(context);
                                  } else {
                                    showToast(
                                        "Plase Enter Your College Mail Id");
                                    emailController.clear();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    'Send Message To Owner',
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a Member?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  InkWell(
                    child: Text(
                      "  Register",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.black.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white38),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Register with college email Id",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextFormField(
                                                    controller: emailController,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Email',
                                                    ),
                                                    validator: (email) => email !=
                                                                null &&
                                                            !EmailValidator
                                                                .validate(email)
                                                        ? "Enter a valid Email"
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    controller:
                                                        passwordController,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Password',
                                                    ),
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) => value !=
                                                                null &&
                                                            value.length < 6
                                                        ? "Enter min. 6 characters"
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    controller:
                                                        passwordController_X,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          'Conform Password',
                                                    ),
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    validator: (value) => value !=
                                                                null &&
                                                            value.length < 6
                                                        ? "Enter min. 6 characters"
                                                        : null,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Text('cancel ',
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (passwordController.text
                                                    .trim() ==
                                                passwordController_X.text
                                                    .trim()) {
                                              signUp();
                                              Navigator.pop(context);
                                            } else {
                                              Utils.showSnackBar(
                                                  "Enter Same Password");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            child: Text(
                                              'Sign up ',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  "Report",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
                onTap: () {
                  _sendingMails("sujithnimmala03@gmail.com");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    var email = emailController.text.trim().split('@');
    if (email[0].length == 10 || email[1] == 'srkrec.ac.in') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
                child: CircularProgressIndicator(),
              ));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim().toLowerCase(),
            password: passwordController.text.trim());
        NotificationService().showNotification(
            title: "Welcome to eSRKR app!",
            body: "Your Successfully Registered!");
        updateToken();
      } on FirebaseException catch (e) {
        print(e);
        Utils.showSnackBar(e.message);
      }
    } else {
      Utils.showSnackBar("Enter email using @srkrec.ac.in");
    }
    Navigator.pop(context);
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim());
      NotificationService()
          .showNotification(title: "Welcome back to eSRKR!", body: null);
      updateToken();
    } on FirebaseException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    Navigator.pop(context);
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    Navigator.pop(context);
    return Navigator.pop(context);
  }
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar =
        SnackBar(content: Text(text), backgroundColor: Colors.orange);
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

_sendingMails(String urlIn) async {
  var url = Uri.parse("mailto:$urlIn");
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}

class Constants {
  static final String BASE_URL = 'https://fcm.googleapis.com/fcm/send';
  static final String KEY_SERVER =
      'AAAA9CTzPoM:APA91bHTk4DcD6fSCJh-EaGH7KreA92u9kpri6o6Sl8euReOgCduR7595Eup4SYfGH6xg1tSaXcZ659kJlQ-ae48H66Ufx-a2xNLl4rlho4EI2A1grpmmuU0JbIsT_Fu7KndWzyDFz9C';
  static final String SENDER_ID = '1048591941251';
}

Future<void> hi(String email) async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";

  FirebaseFirestore.instance
      .collection("tokens")
      .doc(
          "sujithnimmala03@gmail.com") // Replace "documentId" with the ID of the document you want to retrieve
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data();
      if (data != null && data is Map<String, dynamic>) {
        // Access the dictionary values
        String value = data['token'];

        FirebaseFirestore.instance
            .collection("user")
            .doc("sujithnimmala03@gmail.com")
            .collection("Notification")
            .doc(email)
            .set({
          "id": email,
          "Name": email,
          "Time": getTime(),
          "Description": "Forgot Password@$token",
          "Link": ""
        });

        pushNotificationsSpecificDevice(
          title: "Reset Password",
          body: email,
          token: value,
        );
      }
    } else {
      print("Document does not exist.");
    }
  }).catchError((error) {
    print("An error occurred while retrieving data: $error");
  });
}

Future<void> updateToken() async {
  final token = await FirebaseMessaging.instance.getToken() ?? "";
  await FirebaseFirestore.instance.collection("tokens").doc(fullUserId()).set({
    "id": fullUserId(),
    "token": token,
  });
}
