// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/homePage/settings.dart';
import 'functions.dart';
import 'notification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Size  = size(context);

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "eSRKR ",
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
              SizedBox(
                height: Size * 40,
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
                    borderRadius: BorderRadius.circular(Size * 10),
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
                height:  Size  *20,
              ),
              InkWell(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontSize: Size * 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                onTap: () async {
                  if (emailController.text.length > 10) {
                    final String email = emailController.text.trim();
                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Password Reset Email Sent'),
                          content: Text(
                              'An email with instructions to reset your password has been sent to $email.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK',style: TextStyle(fontSize:  Size *14),),
                            ),
                          ],
                        ),
                      );
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(error.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    showToastText("Enter Gmail");
                  }
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
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  InkWell(
                    child: Text(
                      " Register Here",
                      style: TextStyle(
                          fontSize: Size * 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => createNewUser(
                                    size: size(context),
                                  )));
                    },
                  ),
                ],
              ),
              SizedBox(
                height: Size * 20,
              ),
              InkWell(
                child: Text(
                  "Report",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: Size * 20),
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

      updateToken("");
    } on FirebaseException catch (e) {
      showToastText(e.message as String);
      Utils.showSnackBar(e.message);
    }
    Navigator.pop(context);
  }
}

class createNewUser extends StatefulWidget {
  double size;

  createNewUser({required this.size});

  @override
  State<createNewUser> createState() => _createNewUserState();
}

class _createNewUserState extends State<createNewUser> {
  bool isTrue = false;
  bool isSend = false;
  String otp = "";
  List branches = ["ECE", "CIVIL", "CSE", "EEE", "IT", "MECH","AIDS","CSBS","AIML","CSD","CSIT"];
  String branch = "None";
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final gmailController = TextEditingController();
  final passwordController_X = TextEditingController();

  String generateCode() {
    final Random random = Random();
    const characters = '0123456789abcdefghijklmnopqrstuvwxyz';
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += characters[random.nextInt(characters.length)];
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    double Size = widget.size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              backButton(
                  size: Size,
                  text: "Enter College Mail ID",
                  child: SizedBox(
                    width:  Size *45,
                  )),
              SizedBox(
                height: Size * 15,
              ),
              TextFieldContainer(
                  child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                style: textFieldStyle(Size),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter College Mail ID',
                    hintStyle: textFieldHintStyle(Size)),
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? "Enter a valid Email"
                        : null,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isSend)
                    Flexible(
                      child: TextFieldContainer(
                          child: TextFormField(
                        controller: otpController,
                        textInputAction: TextInputAction.next,
                        style: textFieldStyle(Size),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter OPT',
                            hintStyle: textFieldHintStyle(Size)),
                      )),
                    ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:  Size *20),
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular( Size *20)),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(
                              vertical: Size * 5, horizontal: Size * 10),
                          child: Text(
                            isSend ? "Verity" : "Send OTP",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:  Size *30,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (isSend) {
                          if (otp == otpController.text.trim()) {
                            isTrue = true;
                            await FirebaseFirestore.instance
                                .collection("tempRegisters")
                                .doc(emailController.text)
                                .delete();
                          } else {
                            showToastText("Please Enter Correct OTP");
                          }
                        }
                        else {
                          await FirebaseFirestore.instance
                              .collection("tempRegisters")
                              .doc(emailController.text)
                              .get()
                              .then((DocumentSnapshot snapshot) async {
                            if (snapshot.exists) {
                              var data = snapshot.data();
                              if (data != null && data is Map<String, dynamic>) {
                                String value = data['code'];
                                  otp = value;
                                await FirebaseFirestore.instance
                                    .collection("tempRegisters")
                                    .doc(emailController.text)
                                    .set({"email": emailController.text, "code": otp});
                              }
                            }
                            else {
                              otp = generateCode();
                             await FirebaseFirestore.instance
                                  .collection("tempRegisters")
                                  .doc(emailController.text)
                                  .set({"email": emailController.text, "code": otp});
                            }
                            setState(() {
                              otp;
                            });

                          }).catchError((error) {
                            print(
                                "An error occurred while retrieving data: $error");
                          });
                          var email = emailController.text.trim().split('@');
                          if (email[1] == 'srkrec.ac.in') {
                            sendEmail(emailController.text.trim(), otp);
                            String str = emailController.text.substring(6, 8);
                            if (str == '04') {
                              branch = 'ECE';
                            } else if (str == '01') {
                              branch = 'CIVIL';
                            } else if (str == '05') {
                              branch = 'CSE';
                            } else if (str == '02') {
                              branch = 'EEE';
                            } else if (str == '12') {
                              branch = 'IT';
                            } else if (str == '03') {
                              branch = 'MECH';
                            } else if (str == '57') {
                              branch = 'CSBS';
                            } else if (str == '54') {
                              branch = 'AIDS';
                            } else {
                              branch = "None";
                            }
                          }
                          else {
                            if (emailController.text.split('@').last == 'gmail.com') {
                              showToastText("OTP is Not Sent to Email");
                            }
                            else
                              showToastText("Please Enter Correct Email ID");
                          }
                          messageToOwner(
                            emailController.text + "'s code : $otp",
                          );
                          isSend = true;
                        }

                        setState(() {
                          branch;
                          isSend;
                          otp;
                          isTrue;
                        });

                      },
                    ),
                  ),
                ],
              ),
              Text(
                "Your Branch : $branch",
                style: TextStyle(color: Colors.white, fontSize: Size * 20),
              ),
              if (isTrue)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                           EdgeInsets.symmetric(vertical:  Size *15, horizontal:  Size *15),
                      child: Text(
                        "Fill the Details",
                        style: creatorHeadingTextStyle,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFieldContainer(
                              child: TextFormField(
                            controller: firstNameController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(Size),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'First Name',
                                hintStyle: textFieldHintStyle(Size)),
                          )),
                        ),
                        Flexible(
                          child: TextFieldContainer(
                              child: TextFormField(
                            controller: lastNameController,
                            textInputAction: TextInputAction.next,
                            style: textFieldStyle(Size),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Last Name',
                              hintStyle: textFieldHintStyle(Size),
                            ),
                          )),
                        ),
                      ],
                    ),
                    TextFieldContainer(
                        child: TextFormField(
                      controller: gmailController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Personal mail ID',
                          hintStyle: textFieldHintStyle(Size)),
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? "Enter a valid Email"
                              : null,
                    )),
                    TextFieldContainer(
                        child: TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: textFieldHintStyle(Size)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    )),
                    TextFieldContainer(
                        child: TextFormField(
                      obscureText: true,
                      controller: passwordController_X,
                      textInputAction: TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Conform Password',
                        hintStyle: textFieldHintStyle(Size),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 6
                          ? "Enter min. 6 characters"
                          : null,
                    )),
                    Padding(
                      padding:
                           EdgeInsets.symmetric(vertical:  Size *10, horizontal:  Size *10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Selected Branch : $branch",
                            style: creatorHeadingTextStyle,
                          ),
                          if((int.tryParse(emailController.text.substring(0,2))== null&& emailController.text.split("@").last == "srkrec.ac.in")||emailController.text.split("@").last == "gmail.com")ElevatedButton(onPressed: (){
                            setState(() {
                              branch = "None";
                            });
                          }, child: Text("Edit"))
                        ],
                      ),
                    ),
                    if (branch == "None")
                      Padding(
                        padding:  EdgeInsets.all( Size *8.0),
                        child: SizedBox(
                          height:  Size *30,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: branches.length,
                            // Display only top 5 items
                            itemBuilder: (context, int index) {
                              return InkWell(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: branch == branches[index]
                                            ? Colors.white.withOpacity(0.6)
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular( Size *10)),
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(
                                          vertical:  Size *3, horizontal:  Size *8),
                                      child: Text(
                                        "${branches[index]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:  Size *25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                onTap: () {
                                  setState(() {
                                    branch = branches[index];
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                              width:  Size *3,
                            ),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Size * 15),
                        child:
                            Text('cancel ', style: TextStyle(fontSize: Size * 20)),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (passwordController.text.trim() ==
                            passwordController_X.text.trim()) {
                          if (firstNameController.text.isNotEmpty &&
                              lastNameController.text.isNotEmpty &&
                              gmailController.text.isNotEmpty &&
                              branch.isNotEmpty) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                      child: CircularProgressIndicator(),
                                    ));
                            try {

                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email:
                                          emailController.text.trim().toLowerCase(),
                                      password: passwordController.text.trim());

                              NotificationService().showNotification(
                                  title: "Welcome to eSRKR app!",
                                  body: "Your Successfully Registered!");
                              updateToken(branch);
                              newUser(emailController.text.trim().toLowerCase());
                              await FirebaseFirestore.instance
                                  .collection("user")
                                  .doc(emailController.text)
                                  .set({
                                "id": emailController.text,
                                "name": firstNameController.text +
                                    ";" +
                                    lastNameController.text,
                                "gmail": gmailController.text,
                                "branch": branch,
                                "reg": "None"
                              });
                            } on FirebaseException catch (e) {
                              print(e);
                              Utils.showSnackBar(e.message);
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            showToastText("Fill All Details");
                          }
                        } else {
                          showToastText("Enter Same Password");
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Size * 15),
                        child: Text(
                          'Sign up ',
                          style: TextStyle(fontSize: Size * 20),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendEmail(String mail, String otp) async {
    final smtpServer = gmail('esrkr.app@gmail.com', 'wndwwhhpifpgnanu');

    // Create the message
    final message = Message()
      ..from = Address('esrkr.app@gmail.com')
      ..recipients.add(mail)
      ..subject = 'eSRKR App'
      ..text = 'Dear Member,\n\n'
          'Thank you for being a member of eSRKR App. Your Code is: $otp.\n\n'
          'If you have any questions or need assistance, please don\'t hesitate to contact us.\n\n'
          'Best regards,\n'
          'The eSRKR App Team';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
      showToastText('Error sending email: $e');
    }
  }
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
          "id": getID(),
          "fromTo":email,
          "data": "new user@$token",
          "image": ""
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
