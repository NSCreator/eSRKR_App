import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/HomePage.dart';

class unseenImages extends StatefulWidget {
  @override
  _unseenImagesState createState() => _unseenImagesState();
}

class _unseenImagesState extends State<unseenImages> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    _loadImages();
    super.initState();

  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/ece_news/';
    final files = Directory(folderPath).listSync();
    setState(() {
      _imagePaths = files.where((file) => file.path.endsWith('.png')||file.path.endsWith('.jpg')||file.path.endsWith('.jpeg')||file.path.endsWith('.image')).map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("All Saved Images in App",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 25,color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(143, 17, 17,1),Color.fromRGBO(212, 38, 38,1),Color.fromRGBO(212, 55, 38,1),Color.fromRGBO(232, 86, 46,1), Color.fromRGBO(232, 102, 46,1)]
                      ),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("ECE News Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(143, 17, 17,1),Color.fromRGBO(212, 38, 38,1),Color.fromRGBO(212, 55, 38,1),Color.fromRGBO(232, 86, 46,1), Color.fromRGBO(232, 102, 46,1)]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Time Table Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(143, 17, 17,1),Color.fromRGBO(212, 38, 38,1),Color.fromRGBO(212, 55, 38,1),Color.fromRGBO(232, 86, 46,1), Color.fromRGBO(232, 102, 46,1)]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Subject Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(143, 17, 17,1),Color.fromRGBO(212, 38, 38,1),Color.fromRGBO(212, 55, 38,1),Color.fromRGBO(232, 86, 46,1), Color.fromRGBO(232, 102, 46,1)]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Lab Subject Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromRGBO(143, 17, 17,1),Color.fromRGBO(212, 38, 38,1),Color.fromRGBO(212, 55, 38,1),Color.fromRGBO(232, 86, 46,1), Color.fromRGBO(232, 102, 46,1)]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Books Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("You Saved Images",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30,color: Colors.white),),
              ),
              if (_imagePaths.isEmpty) Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ) 
              else ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _imagePaths.length,
                itemBuilder: (BuildContext context, int index) => Row(
                  children: [
                    SizedBox(width: 10,),
                    SizedBox(height:65,child: VerticalDivider(thickness: 3,color: Colors.black,)),
                    Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: FileImage(
                          File(_imagePaths[index]),
                          // fit: BoxFit.cover,
                        ),)
                      ),
                    ),

                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 5,right: 5),
                         child: Text(_imagePaths[index].split("/").last,style:TextStyle(color: Colors.white,fontSize: 18),overflow: TextOverflow.ellipsis,maxLines: 1,),
                       ),
                       InkWell(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Row(
                             children: [
                               Icon(Icons.delete,color: Colors.red,),
                               Text(" Delete",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.w400),)
                             ],
                           ),
                         ),
                         onTap: () async {
                           final file = File(_imagePaths[index]);
                           if (file.existsSync()) {
                             await file.delete();
                           }
                           showToast("${_imagePaths[index].split("/").last} has been deleted");

                         },
                       )
                     ],
                   )
                  ],
                ),
                shrinkWrap: true,

              ),
            ],
          ),
        ),
      )
    );
  }
}

