// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';



TextStyle textFieldStyle() {
  return TextStyle(
    color: Colors. white,
    fontWeight: FontWeight.w500,
    fontSize:   20,
  );
}

TextStyle textFieldHintStyle() {
  return TextStyle(
    color: Colors. white54,
    fontWeight: FontWeight.w300,
    fontSize:   18,
  );
}

class TextFieldContainer extends StatefulWidget {
  Widget child;
  String heading;


  TextFieldContainer({required this.child, this.heading = ""});

  @override
  State<TextFieldContainer> createState() => _TextFieldContainerState();
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left:   10, top:   8,bottom: 2),
            child: Text(
              widget.heading,
              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
            ),
          ),
        Container(
          margin: EdgeInsets.only(left:   10,),
          padding: EdgeInsets.only(
              left:   15,
              right:   10),
          decoration: BoxDecoration(
            color: Colors. white10,
            border: Border.all(color: Colors. black12),
            borderRadius: BorderRadius.circular(  10),
          ),
          child: widget.child,
        ),
      ],
    );
  }
}





