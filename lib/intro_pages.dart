import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'HomePage.dart';
import 'settings.dart';

//TODO intro page
class initial_branch extends StatelessWidget {
  const initial_branch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: FutureBuilder<List<Branch>>(
          future: BranchApi.getUsers(),
          builder: (context, snapshot) {
            final Branches = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Connect to Internet'));
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Select Branch",style: TextStyle(color: Colors.black87,fontSize: 22,fontWeight: FontWeight.w700),),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: Branches!.length,
                          itemBuilder: (context, index) {
                            final branch = Branches[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: const Color.fromRGBO(7, 7, 23, 0.5),
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        child: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 33,
                                            child: ClipOval(
                                                child: Image.network(
                                                  branch.imageUrl,
                                                ))),
                                        onTap: () => _showSecondPage(
                                          context,
                                          branch.imageUrl,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            branch.heading,
                                            style: const TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Electronic",
                                            style: const TextStyle(
                                              fontSize: 19.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('showHome',true);
                                  prefs.setString('branchTitle', branch.heading);
                                  prefs.setString('branchsublink', branch.sublink);
                                  prefs.setString('branchlabsublink', branch.labsublink);
                                  prefs.setString('branchUrl', branch.imageUrl);
                                  prefs.setString('class', "Class");
                                  prefs.setInt('branchIndex', index);
                                  showToast("${branch.heading} is Selected");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => initial_class(),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }

}

class BranchApi {
  static Future<List<Branch>> getUsers() async {
    var url = Uri.parse('https://nscreator.github.io/srkr/srkrAppData.json');
    var response = await http.get(url);
    final body = jsonDecode(response.body);
    return body.map<Branch>(Branch.fromJson).toList();
  }
}

class Branch {
  final String heading;
  final String imageUrl, sublink, labsublink;


  const Branch({
    required this.heading,

    required this.imageUrl,
    required this.sublink,
    required this.labsublink,
  });

  static Branch fromJson(json) => Branch(
      heading: json['name'],
      imageUrl: json['imageLink'],
      sublink: json["subjectsLink"],
      labsublink: json['labSubjectsLink']);
}

class initial_class extends StatelessWidget {
  const initial_class({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: FutureBuilder<List<Class>>(
          future: ClassApi.getUsers(),
          builder: (context, snapshot) {
            final classes = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return const Center(child: Text('Connect to Internet'));
                } else {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Select Year",style: TextStyle(color: Colors.black87,fontSize: 22,fontWeight: FontWeight.w700),),
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: classes!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final classData = classes[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromRGBO(0, 2, 10, 0.4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                          classData.heading,
                                          style: const TextStyle(
                                              color: Colors.white70, fontWeight: FontWeight.w500),
                                        )),
                                  ),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('class', classData.heading);
                                  prefs.setString('Syllabus',classData.syllabusLink);
                                  prefs.setString('ModelPaper', classData.modelPaperLink);
                                  showToast("${classData.heading} is Selected");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40,),
                        Row(children: [
                          Spacer(),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Text("skip",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            onTap: ()=> Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage())),
                          ),
                        ],)
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }

}


_showSecondPage(BuildContext context, String url) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => Scaffold(
        backgroundColor: const Color.fromRGBO(38, 39, 43, 0.4),
        body: Center(
          child: Hero(tag: 'magnifier', child: Image.network(url)),
        ),
      ),
    ),
  );
}
