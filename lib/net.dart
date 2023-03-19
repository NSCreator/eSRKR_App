import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:srkr_study_app/HomePage.dart';

class FirebaseImageDownloader extends StatefulWidget {
  final String imageUrl;

  FirebaseImageDownloader({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _FirebaseImageDownloaderState createState() => _FirebaseImageDownloaderState();
}

class _FirebaseImageDownloaderState extends State<FirebaseImageDownloader> {
  bool downloading = false;
  late String localPath = "";

  Future<void> downloadImage() async {
    setState(() {
      downloading = true;
    });

    final ref = FirebaseStorage.instance.ref().child(widget.imageUrl);
    final url = await ref.getDownloadURL();

    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/${widget.imageUrl}');
    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      downloading = false;
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Image Downloader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (downloading) CircularProgressIndicator() else ElevatedButton(
              onPressed: downloadImage,
              child: Text('Download Image'),
            ),
            SizedBox(height: 20),
            if (localPath.isNotEmpty) Image.file(
              File(localPath),
              height: 200,
            ) else Container(),

            if (localPath.isNotEmpty) Text(localPath) else Container(),

          ],
        ),
      ),
    );
  }
}
