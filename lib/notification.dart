import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'TextField.dart';

class notifications extends StatefulWidget {
  const notifications({Key? key}) : super(key: key);

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image:  NetworkImage("https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg",),fit: BoxFit.fill)
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.black.withOpacity(0.85),
          child: Stack(
            children: [
              StreamBuilder<List<NotificationsConvertor>>(
                    stream: readNotifications(),
                    builder: (context, snapshot) {
                      final Notifications = snapshot.data;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 0.3,
                            color: Colors.cyan,
                          ));
                        default:
                          if (snapshot.hasError) {
                            return const Center(child: Text('Error with TextBooks Data or\n Check Internet Connection'));
                          } else {
                            return ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Notifications!.length,
                                itemBuilder: (context, int index) {
                                  final Notification = Notifications[index];
                                  return InkWell(
                                    child: Padding(
                                      padding: Notification.Name == userId() ? EdgeInsets.only(left: 45,right: 5) : EdgeInsets.only(right: 45,left: 5),
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: Notification.Name == userId()
                                            ? BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                  bottomRight: Radius.circular(5),
                                                ),
                                                color: Colors.black.withOpacity(0.8),
                                          border: Border.all(color: Colors.blueAccent.shade100),
                                              )
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft: Radius.circular(5),
                                                  topRight: Radius.circular(25),
                                                  bottomRight: Radius.circular(25),
                                                ),
                                                color: Colors.black.withOpacity(0.5),
                                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                                              ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "       @${Notification.Name}",
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white54,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(8, 1, 25, 1),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            '${Notification.Time}',
                                                            style: const TextStyle(
                                                              fontSize: 9.0,
                                                              color: Colors.white70,
                                                              //   fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8,bottom: 6,right: 3,top: 3),
                                                  child: RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(text: " ~ ${Notification.description}", style: TextStyle(color: Colors.white, fontSize: 14)),
                                                      if (Notification.Url.length > 5)
                                                        TextSpan(
                                                          text: Notification.Url,
                                                          style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontSize: 15),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              // ignore: deprecated_member_use
                                                              if (await canLaunch(Notification.Url)) {
                                                                // ignore: deprecated_member_use
                                                                await launch(Notification.Url);
                                                              } else {
                                                                throw 'Could not launch ${Notification.Url}';
                                                              }
                                                            },
                                                        ),
                                                    ]),
                                                  ),
                                                ),

                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    onLongPress: (){
                                      if (Notification.Name == userId()||userDomain()=="gmail.com")
                                       {
                                         final deleteFlashNews = FirebaseFirestore.instance.collection("ECE").doc("Notification").collection("AllNotification").doc(Notification.id);
                                         deleteFlashNews.delete();
                                         showToast("Your Message has been Deleted");
                                       }else{
                                        showToast("You are not message user to delete");
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(
                                      height: 1,
                                    ));
                          }
                      }
                    }),
              Align(
                
                alignment: Alignment.bottomCenter,
                child:   Container(
                  color: Colors.black,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                                ),
                                cursorColor: Colors.white,
                                cursorHeight: 20,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Send Message ( All )',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                  ),



                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 2,
                          //fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              child:  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3, right: 3, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text("Send",style: TextStyle(color: Colors.white,fontSize: 17),),
                                      SizedBox(width: 3,),
                                      Icon(Icons.send,color: Colors.blue,)
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                createNotifications(User: userId(), description: emailController.text.trim(), Url: "sd", Time: getTime());
                                emailController.clear();
                              },
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  userId() {
    var user = FirebaseAuth.instance.currentUser!.email!.split("@");
    return user[0];
  }
  userDomain(){
    var user = FirebaseAuth.instance.currentUser!.email!.split("@");
    return user[1];
  }
}
Future showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}

Stream<List<NotificationsConvertor>> readNotifications() => FirebaseFirestore.instance
    .collection('ECE')
    .doc("Notification")
    .collection("AllNotification")
    .orderBy('Time',descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => NotificationsConvertor.fromJson(doc.data())).toList());

Future createNotifications({required String User, required String description, required String Url, required String Time}) async {
  final docflash = FirebaseFirestore.instance.collection("ECE").doc("Notification").collection("AllNotification").doc();
  final flash = NotificationsConvertor(
    id: docflash.id,
    Time: Time,
    Name: User,
    Url: Url,
    description: description,
  );
  final json = flash.toJson();
  await docflash.set(json);
}

class NotificationsConvertor {
  String id;
  final String Name, Url, description, Time;

  NotificationsConvertor({this.id = "", required this.Name, required this.Url, required this.description, required this.Time});

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": Name,
        "Link": Url,
        "Description": description,
        "Time": Time,
      };

  static NotificationsConvertor fromJson(Map<String, dynamic> json) =>
      NotificationsConvertor(id: json['id'], Name: json["Name"], Url: json["Link"], description: json["Description"], Time: json["Time"]);
}
