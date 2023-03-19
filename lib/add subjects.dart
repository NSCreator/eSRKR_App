import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:srkr_study_app/HomePage.dart';

class ImageGrid extends StatefulWidget {
  @override
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory.path}/';
    showToast(folderPath);
    final files = Directory(folderPath).listSync();

    setState(() {
      _imagePaths = files.where((file) => file.path.endsWith('.png')||file.path.endsWith('.jpg')).map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Grid'),
      ),
      body: _imagePaths.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: _imagePaths.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Image.file(
                File(_imagePaths[index]),
                fit: BoxFit.cover,
              ),
            ),
            Text(_imagePaths[index])
          ],
        ),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(
          width: 9,
        ),
      ),
    );
  }
}

