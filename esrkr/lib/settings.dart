import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'authPage.dart';
import 'homepage.dart';
import 'textField.dart';
String ownnerId = "sujithnimmala03@gmail.com";
String noImageUrl = "No Photo Url Available";
String longPressToViewImage = "Long Press To View Image";
class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ Color.fromRGBO(53, 166, 204, 1),Color.fromRGBO(24, 45, 74, 1),Color.fromRGBO(21, 47, 61, 1)]
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:  EdgeInsets.only(left: 10,top: 3),
                    child: Text("User Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:Colors.black.withOpacity(0.4),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child:  Text(userId(),style: TextStyle(color: Colors.white,fontSize: 20),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child:  Text(fullUserId(),style: TextStyle(color: Colors.white,fontSize: 17),),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Liked",style: TextStyle(color: Colors.white,fontSize: 15),),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Subscribed",style: TextStyle(color: Colors.white,fontSize: 15),),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Description : ",style: TextStyle(color: Colors.white,fontSize: 17),),
                          ),
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child:const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Subscription plans",style: TextStyle(color: Colors.white,fontSize: 17),),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text("Editing Options:",style: TextStyle(fontSize: 20,color: Colors.white),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        width: double.infinity,
                                        child: const Padding(
                                          padding:  EdgeInsets.all(11.0),
                                          child:  Text("Add Arduino Board",style: TextStyle(fontSize: 23,color: Colors.white),),
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => arduinoBoardCreator()));

                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        width: double.infinity,
                                        child: const Padding(
                                          padding:  EdgeInsets.all(11.0),
                                          child:  Text("Add Arduino Project",style: TextStyle(fontSize: 23,color: Colors.white),),
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => arduinoProjectCreator()));

                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        width: double.infinity,
                                        child: const Padding(
                                          padding:  EdgeInsets.all(11.0),
                                          child:  Text("Add Raspberry Pi Board",style: TextStyle(fontSize: 23,color: Colors.white),),
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => createNewOne()));

                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        width: double.infinity,
                                        child: const Padding(
                                          padding:  EdgeInsets.all(11.0),
                                          child:  Text("Add Electronic Project",style: TextStyle(fontSize: 23,color: Colors.white),),
                                        ),
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => electronicProjectsCreator()));

                                      },
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Center(child: Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 3),
                            child: Text("Settings",style: TextStyle(fontSize: 25,color: Colors.white),),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Dark Mode",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Cart",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Saved List Projects",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Downloads",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Email Notification",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Telegram Bot Notification",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          SizedBox(height: 50,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text("Privacy Policy",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.4),
                              ),

                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("About",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),),
                              ),
                            ),
                          ),
                          StreamBuilder<List<followUsConvertor>>(
                              stream: readfollowUs(),
                              builder: (context, snapshot) {
                                final Books = snapshot.data;
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
                                      if (Books!.isEmpty) {

                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "No Treading Projects",
                                              style: TextStyle(color: Color.fromRGBO(195, 228, 250, 1),),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 10, top: 20,bottom: 8),
                                              child: Text(
                                                "Follow Us",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Color.fromRGBO(195, 228, 250, 1),),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 40,
                                              child: ListView.separated(
                                                physics: const BouncingScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: Books.length,
                                                itemBuilder: (BuildContext context, int index) => InkWell(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 3),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: const Color.fromRGBO(174, 228, 242,0.15),),
                                                        borderRadius: BorderRadius.circular(15),
                                                        color: Colors.black.withOpacity(0.3),
                                                        // border: Border.all(color: Colors.white),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(15),
                                                              color: Colors.black.withOpacity(0.4),
                                                              image:  DecorationImage(
                                                                image: NetworkImage(
                                                                  Books[index].photoUrl,
                                                                ),
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            height: 35,
                                                            width: 50,
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Text(Books[index].name,style: const TextStyle(fontSize: 16,color: Colors.white),),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                shrinkWrap: true,
                                                separatorBuilder: (context, index) => const SizedBox(
                                                  width: 9,
                                                ),
                                              ),
                                            ),

                                          ],
                                        );
                                      }
                                    }
                                }
                              }),

                          Center(child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20,bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 13,right: 13,top: 8,bottom: 8),
                                  child: Text("Log Out",style: TextStyle(color: Colors.red,fontSize: 16),),
                                ),
                              ),
                            ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.black.withOpacity(0.4),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      elevation: 16,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white30),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            const SizedBox(height: 10),
                                            const SizedBox(height: 5),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 15),
                                              child: Text(
                                                "Do you want Log Out",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Spacer(),
                                                  InkWell(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white24,
                                                        border: Border.all(color: Colors.black),
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      child: const Padding(
                                                        padding:  EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                        child: Text("Back", style: TextStyle(color: Colors.white),),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        border: Border.all(color: Colors.black),
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      child:const Padding(
                                                        padding:  EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                        child: Text(
                                                          "Log Out",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      FirebaseAuth.instance.signOut();
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );

                              }
                          ),
                          )
                        ],
                      ),
                    ),
                  )

                ],
              ),
            )));
  }
}

Stream<List<followUsConvertor>> readfollowUs() => FirebaseFirestore.instance
    .collection('FollowUs')
    .orderBy("name", descending: false)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => followUsConvertor.fromJson(doc.data())).toList());

class followUsConvertor {
  String id;
  final String name,link,photoUrl;



  followUsConvertor({this.id = "",required this.name,required this.link,required this.photoUrl});

  static followUsConvertor fromJson(Map<String, dynamic> json) =>
      followUsConvertor(id: json['id'],name: json["name"],link: json["link"],photoUrl: json["photoUrl"]);
}


userId() {
  var user = FirebaseAuth.instance.currentUser!.email!.split("@");
  return user[0];
}

fullUserId() {
  var user = FirebaseAuth.instance.currentUser!.email!;
  return user;
}
