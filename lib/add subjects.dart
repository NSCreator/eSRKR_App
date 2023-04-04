import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:srkr_study_app/HomePage.dart';
import 'package:srkr_study_app/settings.dart';

import 'ads.dart';

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
    final folderPath = '${directory.path}/${fullUserId()}/';

    final files = Directory(folderPath).listSync();
    setState(() {
      _imagePaths = files.where((file) => file.path.endsWith('.png')||file.path.endsWith('.jpg')||file.path.endsWith('.jpeg')||file.path.endsWith('.image')).map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),fit: BoxFit.fill)
        ),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Saved PDFS (In App)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30,color: Colors.orange),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                            child: Text(".pdf .txt .ppt etc.,",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "pdfs", heading: 'Saved .pdf .txt .ppt',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Saved Images (In App)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30,color: Colors.orange),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                            child: Text("ECE Updates Images",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.arrow_forward_ios,color: Colors.white,),
                          )
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_updates", heading: 'Saved Updates',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_news", heading: 'Saved News',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_timetable", heading: 'Time Table Images',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_subjects", heading: 'Saved Subjects',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_labsubjects", heading: 'Saved Lab Subjects',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                  child: InkWell(
                    child: Container(
                      height: 50,
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Images(path: "ece_books", heading: 'Saved Books',)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("You Saved Images",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 30,color: Colors.orangeAccent),),
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
                      SizedBox(height:65,child: VerticalDivider(thickness: 3,color: Colors.orangeAccent,)),
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
        ),
      )
    );
  }
}

class Images extends StatefulWidget {
  String path = "";
  String heading;
   Images({Key? key,required this.path,required this.heading}) : super(key: key);

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    _loadImages();
    super.initState();

  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/${widget.path}/';
    final files = Directory(folderPath).listSync();
    setState(() {
      _imagePaths = files.where((file) => file.path.endsWith('.png')||file.path.endsWith('.pdf')||file.path.endsWith('.firebase')||file.path.endsWith('.jpg')||file.path.endsWith('.jpeg')||file.path.endsWith('.image')).map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage("https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),fit: BoxFit.fill)
        ),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.heading,style: TextStyle(color: Colors.orange,fontSize: 35),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 25),
                child: Text("Note : After deleting the images restart the app",style: TextStyle(color: Colors.red,fontSize: 15),),
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
                itemBuilder: (BuildContext context, int index) => InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [

                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: FileImage(
                                  File(_imagePaths[index]),

                                ),fit: BoxFit.cover,)
                            ),
                          ),
                        ),

                        Flexible(
                          flex: 4,
                          child: Column(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    if(widget.path == "pdfs")Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewerPage(pdfUrl: _imagePaths[index])));
                  },
                ),
                shrinkWrap: true,

              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PDFViewController pdfController;
  int currentPage = 0;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: false,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                isReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              pdfController = vc;
            },

          ),
          !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Offstage(),
          Align(
              alignment: Alignment.bottomCenter,
              child: CustomAdsBannerForPdfs()
          ),
        ],
      ),


floatingActionButton: InkWell(
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: MediaQuery.of(context).orientation == Orientation.portrait ?
    Icon(Icons.rotate_90_degrees_cw,size: 35,color: Colors.black.withOpacity(0.6),)
        :Icon(Icons.rotate_90_degrees_ccw,size: 35,color: Colors.black.withOpacity(0.6)),
  ),
  onTap: (){
    if (MediaQuery.of(context).orientation == Orientation.portrait){
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft]);
    }else{
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    }
  },
),
    );
  }
}

showToast(String message) async {
  await Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message, fontSize: 18);
}