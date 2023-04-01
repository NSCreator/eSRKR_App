import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TextField.dart';
import 'main.dart';
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
  final passwordController_X = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color:Colors.grey[400],
          image: DecorationImage(image: NetworkImage("https://cutewallpaper.org/34/education-phone-wallpaper/315537679.jpg"),
          fit: BoxFit.fill)
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 25,bottom: 5),
                           child: SizedBox(
                               height: 200,
                               width: 200,
                               child: Image.network("https://i.pinimg.com/originals/69/81/de/6981deb6aedd16d4c49fa177ccbb2735.gif")),
                         ),
                         Text(
                           "e-SRKR",
                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                         ),
                         SizedBox(
                           height: 10,
                         ),
                         Text(
                           "Welcome Back!",
                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                         ),
                       ],
                     ),
                      //email textfield
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
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
                            color: Colors.grey[200],
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
                        child: Text("Note : LogIn with Your RegisterNumber@srkrec.ac.in",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      ),
                      //sign in button
                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: Text(
                              "Sign In",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            )),
                          ),
                          onTap: signIn,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: Text(
                          "Forgot Password? ( Owner )",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.tealAccent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Reset Password',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Ends with @gmail.com can Reset Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,right: 5),
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
                                              validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid Email" : null,
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
                      SizedBox(height: 10,),
                      InkWell(
                        child: Text(
                          "Forgot Password? ( Student )",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.tealAccent),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Reset Password',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Ends with @srkrec.ac.in can Reset Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 5,right: 5),
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
                                              validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid Email" : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Note :In Few Days Your Account Has Been Deleted and Create New One.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if(emailController.text.trim().split("@").last.toLowerCase()=="srkrec.ac.in")
                                          {
                                            createNotifications(User: emailController.text.trim(), description: "${emailController.text.trim()} ( Forgot Password )", Url: "sd", Time: getTime());
                                            showToast("Message Has Been Send.");
                                            emailController.clear();
                                            Navigator.pop(context);
                                          }else{
                                            showToast("Plase Enter Your College Mail Id");
                                            emailController.clear();
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Text('Send Notification'),
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          InkWell(
                            child: Text(
                              " Register",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.cyan),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      backgroundColor: Colors.grey[100],
                                      title: Text(
                                        'Create Account',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            children: <Widget>[
                                              Text("Register with college email Id"),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
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
                                                    validator: (email) => email != null && !EmailValidator.validate(email) ? "Enter a valid Email" : null,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    controller: passwordController,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Password',
                                                    ),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    validator: (value) => value != null && value.length < 6 ? "Enter min. 6 characters" : null,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(color: Colors.white),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: TextFormField(
                                                    obscureText: true,
                                                    controller: passwordController_X,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Conform Password',
                                                    ),
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    validator: (value) => value != null && value.length < 6 ? "Enter min. 6 characters" : null,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Text('cancel '),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            if(passwordController.text.trim()==passwordController_X.text.trim()){
                                            signUp();
                                            }else{
                                              Utils.showSnackBar("Enter same password");
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Text('Sign up '),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        child: Text(
                          "Report",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                        onTap:(){
                          _sendingMails(
                            "sujithnimmala03@gmail.com");
                          },
                      ),
                    ],
                  ),
                ),
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
    if (email[0].length == 10||email[1] == 'srkrec.ac.in') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
                child: CircularProgressIndicator(),
              ));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim().toLowerCase(), password: passwordController.text.trim());
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
        await FirebaseAuth.instance.signInWithEmailAndPassword( email: emailController.text.trim().toLowerCase(), password: passwordController.text.trim());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Nav()));
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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
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
    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.orange);
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