// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class zoom extends StatefulWidget {
  String url;
  zoom({Key? key,required this.url}) : super(key: key);

  @override
  State<zoom> createState() => _zoomState();
}

class _zoomState extends State<zoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PhotoView(imageProvider: NetworkImage(widget.url),
      ),
    ));
  }
}
