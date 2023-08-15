import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/TextField.dart';
import 'package:srkr_study_app/settings.dart';
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
Navigator.push(context, MaterialPageRoute(builder: (context)=>createNewUser(size: size(context),)));
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
      showToastText(e.message as String);
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

class createNewUser extends StatefulWidget {
  double size;
   createNewUser({required this.size});

  @override
  State<createNewUser> createState() => _createNewUserState();
}

class _createNewUserState extends State<createNewUser> {
  bool isTrue=false;
  bool isSend=false;
  String otp="";
  List branches=["ECE","CIVIL","CSE","EEE","IT","MECH"];
  String branch ="";
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
    double Size =widget.size;
    return backGroundImage(
      child:Column(
        children: [
          Padding(
            padding:
            EdgeInsets.all(widget.size * 8.0),
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
                    hintText: 'Enter College Mail ID',
                    hintStyle:
                    textFieldHintStyle(Size)),
                validator: (email) => email !=
                    null &&
                    !EmailValidator.validate(
                        email)
                    ? "Enter a valid Email"
                    : null,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(isSend)Flexible(
                child: TextFieldContainer(
                    child: TextFormField(
                      controller: otpController,
                      textInputAction:
                      TextInputAction.next,
                      style: textFieldStyle(Size),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter OPT',
                          hintStyle:
                          textFieldHintStyle(Size)),

                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      child: Text(isSend?"Verity":"Send OTP",style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.w600),),
                    ),
                  ),
                  onTap: () async {

                   if(isSend){
                     if(otp==otpController.text){
                       setState(() {
                         isTrue=true;
                       });
                     }else{
                       showToastText("Please Enter Correct OTP");
                     }
                   }else{
                     var email = emailController.text.trim().split('@');
                     if (email[0].length == 10 && email[1] == 'srkrec.ac.in')
                     {
                       otp =generateCode();
                       FirebaseFirestore.instance.collection("tempRegisters").doc(emailController.text).set({"email":emailController.text,
                         "opt":otp});
                       sendEmail(emailController.text,otp);
                       setState(() {
                         otp;
                         isSend = true;
                       });
                     }else{
                       showToastText("Please Enter Correct Email ID");
                     }

                   }

                  },
                ),
              ),
            ],
          ),
          if(isTrue)Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                child: Text("Fill the Details",style: creatorHeadingTextStyle,),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFieldContainer(
                        child: TextFormField(

                          controller: firstNameController,
                          textInputAction:
                          TextInputAction.next,
                          style: textFieldStyle(Size),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'First Name',
                              hintStyle:
                              textFieldHintStyle(Size)),

                        )),
                  ),
                  Flexible(
                    child: TextFieldContainer(child: TextFormField(
                      controller:lastNameController,
                      textInputAction:
                      TextInputAction.next,
                      style: textFieldStyle(Size),

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                        'Last Name',

                        hintStyle:
                        textFieldHintStyle(Size),
                      ),

                    )),
                  ),
                ],
              ),
              TextFieldContainer(
                  child: TextFormField(
                    controller: gmailController,
                    textInputAction:
                    TextInputAction.next,
                    style: textFieldStyle(Size),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Personal mail ID',
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
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Text("Selected Branch : $branch",style: creatorHeadingTextStyle,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: branches.length, // Display only top 5 items
                    itemBuilder: (context, int index) {

                        return InkWell(
                          child: Container(
                              decoration: BoxDecoration(

                                  color: branch==branches[index]?Colors.white.withOpacity(0.6):Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
                                child: Text("${branches[index]}",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                              )),
                          onTap: (){
                            setState(() {
                              branch = branches[index];
                            });
                          },
                        );

                    },
                    separatorBuilder: (context,index)=>SizedBox(width: 3,),),
                ),
              ),
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
                onPressed: () async {
                  if (passwordController.text
                      .trim() ==
                      passwordController_X.text
                          .trim()) {
                    if(firstNameController.text.isNotEmpty&&lastNameController.text.isNotEmpty&&gmailController.text.isNotEmpty&&branch.isNotEmpty){

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ));
                      try {
                        await FirebaseFirestore.instance.collection("user").doc(emailController.text).set({
                          "id":emailController.text,
                          "name":firstNameController.text+";"+lastNameController.text,
                          "gmail":gmailController.text,
                          "branch":branch,
                          "index":0,
                          "reg":""
                        });
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text.trim().toLowerCase(),
                            password: passwordController.text.trim());

                        NotificationService().showNotification(
                            title: "Welcome to eSRKR app!",
                            body: "Your Successfully Registered!");
                        updateToken();
                        newUser(emailController.text.trim().toLowerCase());
                      } on FirebaseException catch (e) {
                        print(e);
                        Utils.showSnackBar(e.message);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }else{
                      showToastText("Fill All Details");
                    }


                  } else {
                    showToastText(
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
          ),

        ],
      ) ,
    );
  }
  Future<void> sendEmail(String mail,String otp) async {
    final smtpServer = gmail('esrkr.app@gmail.com', 'wndwwhhpifpgnanu');

    // Create the message
    final message = Message()
      ..from = Address('esrkr.app@gmail.com')
      ..recipients.add(mail)
      ..subject = 'OTP for eSRKR App'
      ..text = 'Your Otp is $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
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
