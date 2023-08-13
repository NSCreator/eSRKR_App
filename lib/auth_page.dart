import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/TextField.dart';
import 'functins.dart';
import 'notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double Size = 1;
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
    setState(() {
      Size = size(context);
    });
    return backGroundImage(
        child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "e-SRKR ",
                style: TextStyle(
                    fontSize: Size * 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepOrange),
              ),
              SizedBox(
                height: Size * 10,
              ),
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: Size * 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              //email textfield
              SizedBox(
                height: Size * 30,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Size * 25),
                child: TextFieldContainer(
                  child: TextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Colors.white, fontSize: Size * 20),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Colors.white54, fontSize: Size * 20)),
                  ),
                ),
              ),
              //password

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Size * 25),
                child: TextFieldContainer(
                    child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.white, fontSize: Size * 20),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.white54, fontSize: Size * 20)),
                )),
              ),

              Padding(
                padding: EdgeInsets.all(Size * 8.0),
                child: Text(
                  "Note : LogIn with Your RegisterNumber@srkrec.ac.in",
                  style: TextStyle(
                      fontSize: Size * 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70),
                ),
              ),
              //sign in button
              SizedBox(
                height: Size * 10,
              ),

              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Size * 20, vertical: Size * 10),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(Size * 15),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: Size * 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
                      fontSize: Size * 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Size * 20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(Size * 20),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(Size * 10.0),
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: Size * 25),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(Size * 8.0),
                                child: Text(
                                  "Ends with @gmail.com can Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Size * 18),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Size * 5),
                                child: TextFieldContainer(
                                  child: TextFormField(
                                    controller: emailController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                            color: Colors.white54,
                                            fontSize: Size * 20)),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Size * 20),
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? "Enter a valid Email"
                                        : null,
                                  ),
                                ),
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    resetPassword();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(Size * 5.0),
                                    child: Text(
                                      'ReSet',
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: Size * 30,
                                          fontWeight: FontWeight.w600),
                                    ),
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
                height: 10,
              ),
              InkWell(
                child: Text(
                  "Forgot Password? ( Student )",
                  style: TextStyle(
                      fontSize: Size * 15,
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
                            borderRadius: BorderRadius.circular(Size * 20)),
                        elevation: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(Size * 20),
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
                                      fontSize: Size * 20),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(Size * 8.0),
                                child: Text(
                                  "Ends with @srkrec.ac.in can Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Size * 15),
                                ),
                              ),
                              TextFieldContainer(
                                  child: TextFormField(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                style: textFieldStyle(Size),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Your College Gmail Id',
                                    hintStyle: textFieldHintStyle(Size)),
                                validator: (email) => email != null &&
                                        !EmailValidator.validate(email)
                                    ? "Enter a valid Email"
                                    : null,
                              )),
                              Padding(
                                padding: EdgeInsets.all(Size * 8.0),
                                child: Text(
                                  "Note : In Few Days Your Account Has Been Deleted and Create New One.",
                                  style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.w500,
                                      fontSize: Size * 15),
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
                                    showToastText("Message Has Been Send.");
                                    Navigator.pop(context);
                                  } else {
                                    showToastText(
                                        "Plase Enter Your College Mail Id");
                                    emailController.clear();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: Size * 15),
                                  child: Text(
                                    'Send Message To Owner',
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: Size * 20),
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
                height: Size * 20,
              ),
              Wrap(
                children: [
                  Text(
                    "Not a Member?",
                    style: TextStyle(
                        fontSize: Size * 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  InkWell(
                    child: Text(
                      "  Register",
                      style: TextStyle(
                          fontSize: Size * 23,
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
                                  borderRadius:
                                      BorderRadius.circular(Size * 20)),
                              elevation: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white38),
                                  borderRadius:
                                      BorderRadius.circular(Size * 20),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(Size * 1.0),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  EdgeInsets.all(Size * 8.0),
                                              child: Text(
                                                "Register with college email Id",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: Size * 20),
                                              ),
                                            ),
                                            SizedBox(
                                              height: Size * 15,
                                            ),
                                            TextFieldContainer(
                                                child: TextFormField(
                                              controller: emailController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: textFieldStyle(Size),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Email',
                                                  hintStyle:
                                                      textFieldHintStyle(Size)),
                                              validator: (email) => email !=
                                                          null &&
                                                      !EmailValidator.validate(
                                                          email)
                                                  ? "Enter a valid Email"
                                                  : null,
                                            )),
                                            TextFieldContainer(
                                                child: TextFormField(
                                              obscureText: true,
                                              controller: passwordController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: textFieldStyle(Size),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Password',
                                                  hintStyle:
                                                      textFieldHintStyle(Size)),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                          null &&
                                                      value.length < 6
                                                  ? "Enter min. 6 characters"
                                                  : null,
                                            )),
                                            TextFieldContainer(child: TextFormField(
                                              obscureText: true,
                                              controller:
                                              passwordController_X,
                                              textInputAction:
                                              TextInputAction.next,
                                              style: textFieldStyle(Size),

                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                'Conform Password',

                                                  hintStyle:
                                                  textFieldHintStyle(Size),
                                              ),
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) => value !=
                                                  null &&
                                                  value.length < 6
                                                  ? "Enter min. 6 characters"
                                                  : null,
                                            ))
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
                                            padding:  EdgeInsets.only(
                                                right:Size* 15),
                                            child: Text('cancel ',
                                                style: TextStyle(fontSize: Size*20)),
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
                                            padding:  EdgeInsets.only(
                                                right: Size*15),
                                            child: Text(
                                              'Sign up ',
                                              style: TextStyle(fontSize:Size* 20),
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

                height:Size * 10,
              ),
              InkWell(
                child: Text(
                  "Report",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                      fontSize: Size*20),
                ),
                onTap: () {
                  sendingMails("sujithnimmala03@gmail.com");
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    var email = emailController.text.trim().split('@');
    if (email[0].length == 10 && email[1] == 'srkrec.ac.in') {
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
        newUser(emailController.text.trim().toLowerCase());
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        print(e);
        Utils.showSnackBar(e.message);
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Utils.showSnackBar("Enter email using @srkrec.ac.in");
    }
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
      NotificationService().showNotification(
          title: "Reset Password", body: "Reset Link is Send To Your Email");
      Utils.showSnackBar("Password Reset Email Sent");
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
    Navigator.pop(context);
    return Navigator.pop(context);
  }
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
          "Time": getDate(),
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

Future<void> newUser(String email) async {
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
          "Time": getDate(),
          "Description": "new user@$token",
          "Link": ""
        });

        pushNotificationsSpecificDevice(
          title: "New user to our family!",
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
