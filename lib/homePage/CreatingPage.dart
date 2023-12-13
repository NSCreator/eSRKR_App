import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../TextField.dart';
import '../functions.dart';
import '../net.dart';
import '../notification.dart';
import '../test.dart';
import 'HomePage.dart';

class CreatePage extends StatefulWidget {
  double size;
  String branch, reg;

  CreatePage({required this.size, required this.reg, required this.branch});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    double Size = widget.size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Size * 10, vertical: Size * 10),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(right: Size * 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius:
                            BorderRadius.all(Radius.circular(Size * 15))),
                        child: Padding(
                          padding: EdgeInsets.all(Size * 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Text To Speech",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Size * 25,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                height: Size * 25,
                                width: Size * 25,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: AssetImage("assets/img.png")),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Size * 20))),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                              MyHomePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final fadeTransition = FadeTransition(
                              opacity: animation,
                              child: child,
                            );

                            return Container(
                              color: Colors.black.withOpacity(animation.value),
                              child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity: animation.value.clamp(0.3, 1.0),
                                  child: fadeTransition),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                    child: InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                            BorderRadius.all(Radius.circular(Size * 15))),
                        child: Padding(
                          padding: EdgeInsets.all(Size * 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Ask",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Size * 25,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                height: Size * 30,
                                width: Size * 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white24),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Size * 15))),
                                child: Padding(
                                  padding: EdgeInsets.all(Size * 3.0),
                                  child: Text(
                                    "AI",
                                    style: TextStyle(
                                        fontSize: Size * 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showToastText("Coming Soon");
                      },
                    ))
              ],
            ),
          ),
          // if (isGmail() || isOwner())
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Column(
          //       children: [
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             InkWell(
          //               child: Container(
          //                 padding:
          //                     EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //                 margin: EdgeInsets.only(bottom: 5, left: 2, top: 10),
          //                 decoration: BoxDecoration(
          //                     color: Colors.white12,
          //                     borderRadius: BorderRadius.circular(10)),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     Row(
          //                       children: [
          //                         Icon(
          //                           Icons.add_box_outlined,
          //                           color: Colors.white70,
          //                           size: widget.size * 25,
          //                         ),
          //                         Text(
          //                           " Create Regulation by R2_",
          //                           style: TextStyle(
          //                               color: Colors.white, fontSize: 25),
          //                         ),
          //                       ],
          //                     ),
          //                     Icon(
          //                       Icons.chevron_right,
          //                       size: 25,
          //                       color: Colors.white54,
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               onTap: () {
          //                 showDialog(
          //                   context: context,
          //                   builder: (context) {
          //                     var InputController;
          //                     return Dialog(
          //                       backgroundColor: Colors.black.withOpacity(0.3),
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(
          //                               widget.size * 20)),
          //                       elevation: 16,
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                           color: Colors.black,
          //                           border: Border.all(color: Colors.white24),
          //                           borderRadius:
          //                               BorderRadius.circular(widget.size * 20),
          //                         ),
          //                         child: ListView(
          //                           shrinkWrap: true,
          //                           children: <Widget>[
          //                             SizedBox(height: widget.size * 15),
          //                             Padding(
          //                               padding: EdgeInsets.only(
          //                                   left: widget.size * 15),
          //                               child: Text(
          //                                 "Add Regulation by Entering r20",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontWeight: FontWeight.w600,
          //                                     fontSize: widget.size * 18),
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: EdgeInsets.symmetric(
          //                                   horizontal: widget.size * 10),
          //                               child: TextFieldContainer(
          //                                 child: TextField(
          //                                   controller: InputController,
          //                                   textInputAction:
          //                                       TextInputAction.next,
          //                                   style: TextStyle(
          //                                       color: Colors.white,
          //                                       fontSize: widget.size * 20),
          //                                   decoration: InputDecoration(
          //                                       border: InputBorder.none,
          //                                       hintText:
          //                                           'r2_ <= Enter Regulation Number',
          //                                       hintStyle: TextStyle(
          //                                           color: Colors.white70,
          //                                           fontSize:
          //                                               widget.size * 20)),
          //                                 ),
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               height: widget.size * 5,
          //                             ),
          //                             Center(
          //                               child: Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.center,
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.center,
          //                                 children: [
          //                                   Spacer(),
          //                                   InkWell(
          //                                     child: Container(
          //                                       decoration: BoxDecoration(
          //                                         color: Colors.black26,
          //                                         border: Border.all(
          //                                             color: Colors.white
          //                                                 .withOpacity(0.3)),
          //                                         borderRadius:
          //                                             BorderRadius.circular(
          //                                                 widget.size * 25),
          //                                       ),
          //                                       child: Padding(
          //                                         padding: EdgeInsets.symmetric(
          //                                             horizontal:
          //                                                 widget.size * 15,
          //                                             vertical:
          //                                                 widget.size * 5),
          //                                         child: Text(
          //                                           "Back",
          //                                           style: TextStyle(
          //                                               color: Colors.white,
          //                                               fontSize:
          //                                                   widget.size * 14),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     onTap: () {
          //                                       Navigator.pop(context);
          //                                     },
          //                                   ),
          //                                   SizedBox(
          //                                     width: widget.size * 10,
          //                                   ),
          //                                   InkWell(
          //                                     child: Container(
          //                                       decoration: BoxDecoration(
          //                                         color: Colors.red,
          //                                         border: Border.all(
          //                                             color: Colors.black),
          //                                         borderRadius:
          //                                             BorderRadius.circular(
          //                                                 widget.size * 25),
          //                                       ),
          //                                       child: Padding(
          //                                         padding: EdgeInsets.symmetric(
          //                                             horizontal:
          //                                                 widget.size * 15,
          //                                             vertical:
          //                                                 widget.size * 5),
          //                                         child: Text(
          //                                           "ADD + ",
          //                                           style: TextStyle(
          //                                               color: Colors.white,
          //                                               fontSize:
          //                                                   widget.size * 14),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     onTap: () async {
          //                                       showDialog(
          //                                         context: context,
          //                                         barrierDismissible: false,
          //                                         // Prevents dismissing the dialog by tapping outside
          //                                         builder: (context) {
          //                                           return AlertDialog(
          //                                             content: Column(
          //                                               mainAxisSize:
          //                                                   MainAxisSize.min,
          //                                               children: [
          //                                                 CircularProgressIndicator(),
          //                                                 SizedBox(height: 16),
          //                                                 Text('Creating...'),
          //                                               ],
          //                                             ),
          //                                           );
          //                                         },
          //                                       );
          //                                       String reg =
          //                                           InputController.text;
          //                                       for (int year = 1;
          //                                           year <= 4;
          //                                           year++) {
          //                                         for (int sem = 1;
          //                                             sem <= 2;
          //                                             sem++) {
          //                                           print(
          //                                               "${reg.toLowerCase()} $year year $sem sem");
          //                                           await FirebaseFirestore
          //                                               .instance
          //                                               .collection(
          //                                                   widget.branch)
          //                                               .doc("regulation")
          //                                               .collection(
          //                                                   "regulationWithYears")
          //                                               .doc(
          //                                                   "${reg.toLowerCase()} $year year $sem sem"
          //                                                       .substring(
          //                                                           0, 10))
          //                                               .set({
          //                                             "id":
          //                                                 "${reg.toLowerCase()} $year year $sem sem"
          //                                                     .substring(0, 10),
          //                                             "syllabus": "",
          //                                             "modelPaper": "",
          //                                           });
          //                                           await createRegulationSem(
          //                                               name:
          //                                                   "${reg.toLowerCase()} $year year $sem sem",
          //                                               branch: widget.branch);
          //                                         }
          //                                       }
          //                                       messageToOwner(
          //                                           "Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
          //                                       Navigator.pop(context);
          //                                       Navigator.pop(context);
          //                                     },
          //                                   ),
          //                                   SizedBox(
          //                                     width: widget.size * 20,
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               height: widget.size * 10,
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 );
          //               },
          //             ),
          //             Text(
          //               "Create New",
          //               style: TextStyle(
          //                   color: Colors.orangeAccent.withOpacity(0.8),
          //                   fontSize: 22),
          //             ),
          //             Row(
          //               children: [
          //                 Flexible(
          //                   child: InkWell(
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 10, vertical: 5),
          //                       margin: EdgeInsets.only(
          //                           bottom: 5, right: 2, top: 10),
          //                       decoration: BoxDecoration(
          //                           color: Colors.white12,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Expanded(
          //                             child:                                    Row(
          //                               children: [
          //                                 Icon(
          //                                   Icons.add_box_outlined,
          //                                   color: Colors.white70,
          //                                   size: widget.size * 25,
          //                                 ),
          //                                 Expanded(
          //                                   child: Text(
          //                                     " Flash News",
          //                                     style: TextStyle(
          //                                         color: Colors.white,
          //                                         fontSize: 25),maxLines:1
          //                                   ),
          //                                 ),
          //
          //                               ],
          //                             ),
          //
          //                           ),
          //                           Icon(
          //                             Icons.chevron_right,
          //                             size: 25,
          //                             color: Colors.white54,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => flashNewsCreator(
          //                                     branch: widget.branch,
          //                                     size: widget.size,
          //                                   )));
          //                     },
          //                   ),
          //                 ),
          //                 Flexible(
          //                   child: InkWell(
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 10, vertical: 5),
          //                       margin: EdgeInsets.only(
          //                           bottom: 5, left: 2, top: 10),
          //                       decoration: BoxDecoration(
          //                           color: Colors.white12,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.add_box_outlined,
          //                                 color: Colors.white70,
          //                                 size: widget.size * 25,
          //                               ),
          //                               Text(
          //                                 " News",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 25),
          //                               ),
          //                             ],
          //                           ),
          //                           Icon(
          //                             Icons.chevron_right,
          //                             size: 25,
          //                             color: Colors.white54,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => updateCreator(
          //                                     branch: widget.branch,
          //                                     size: widget.size,
          //                                   )));
          //                     },
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Create Materials",
          //               style: TextStyle(
          //                   color: Colors.orangeAccent.withOpacity(0.8),
          //                   fontSize: 22),
          //             ),
          //             Row(
          //               children: [
          //                 Flexible(
          //                   child: InkWell(
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 10, vertical: 5),
          //                       margin: EdgeInsets.only(
          //                           bottom: 5, right: 2, top: 10),
          //                       decoration: BoxDecoration(
          //                           color: Colors.white12,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.add_box_outlined,
          //                                 color: Colors.white70,
          //                                 size: widget.size * 25,
          //                               ),
          //                               Text(
          //                                 " Subject",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 25),
          //                               ),
          //                             ],
          //                           ),
          //                           Icon(
          //                             Icons.chevron_right,
          //                             size: 25,
          //                             color: Colors.white54,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => SubjectsCreator(
          //                                     size: widget.size,
          //                                     branch: widget.branch,
          //                                   )));
          //                     },
          //                   ),
          //                 ),
          //                 Flexible(
          //                   child: InkWell(
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 10, vertical: 5),
          //                       margin: EdgeInsets.only(
          //                           bottom: 5, left: 2, top: 10),
          //                       decoration: BoxDecoration(
          //                           color: Colors.white12,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.add_box_outlined,
          //                                 color: Colors.white70,
          //                                 size: widget.size * 25,
          //                               ),
          //                               Text(
          //                                 " Lab Subject",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 25),
          //                               ),
          //                             ],
          //                           ),
          //                           Icon(
          //                             Icons.chevron_right,
          //                             size: 25,
          //                             color: Colors.white54,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => SubjectsCreator(
          //                                     size: widget.size,
          //                                     branch: widget.branch,
          //                                   )));
          //                     },
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             Row(
          //               children: [
          //                 Flexible(
          //                   child: InkWell(
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: 10, vertical: 5),
          //                       margin: EdgeInsets.only(bottom: 5, right: 2),
          //                       decoration: BoxDecoration(
          //                           color: Colors.white12,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceBetween,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.add_box_outlined,
          //                                 color: Colors.white70,
          //                                 size: widget.size * 25,
          //                               ),
          //                               Text(
          //                                 " Books",
          //                                 style: TextStyle(
          //                                     color: Colors.white,
          //                                     fontSize: 25),
          //                               ),
          //                             ],
          //                           ),
          //                           Icon(
          //                             Icons.chevron_right,
          //                             size: 25,
          //                             color: Colors.white54,
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     onTap: () {
          //                       Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => BooksCreator(
          //                                     branch: widget.branch,
          //                                   )));
          //                     },
          //                   ),
          //                 ),
          //                 Flexible(
          //                   child: Container(),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Flexible(
          //               child: InkWell(
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(
          //                       horizontal: 10, vertical: 5),
          //                   margin:
          //                       EdgeInsets.only(bottom: 5, right: 2, top: 10),
          //                   decoration: BoxDecoration(
          //                       color: Colors.white12,
          //                       borderRadius: BorderRadius.circular(10)),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Row(
          //                         children: [
          //                           Icon(
          //                             Icons.add_box_outlined,
          //                             color: Colors.white54,
          //                             size: widget.size * 25,
          //                           ),
          //                           Text(
          //                             " Time Table",
          //                             style: TextStyle(
          //                                 color: Colors.white, fontSize: 25),
          //                           ),
          //                         ],
          //                       ),
          //                       Icon(
          //                         Icons.chevron_right,
          //                         size: 25,
          //                         color: Colors.white54,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) =>
          //                               timeTableSyllabusModalPaperCreator(
          //                                 size: widget.size,
          //                                 mode: 'Time Table',
          //                                 reg: widget.reg,
          //                                 branch: widget.branch,
          //                               )));
          //                 },
          //               ),
          //             ),
          //             Flexible(
          //               child: Container(),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Flexible(
          //               child: InkWell(
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(
          //                       horizontal: 10, vertical: 5),
          //                   margin:
          //                       EdgeInsets.only(bottom: 5, right: 2, top: 10),
          //                   decoration: BoxDecoration(
          //                       color: Colors.white12,
          //                       borderRadius: BorderRadius.circular(10)),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Row(
          //                         children: [
          //                           Icon(
          //                             Icons.add_box_outlined,
          //                             color: Colors.white54,
          //                             size: widget.size * 25,
          //                           ),
          //                           Text(
          //                             " Syllabus",
          //                             style: TextStyle(
          //                                 color: Colors.white, fontSize: 25),
          //                           ),
          //                         ],
          //                       ),
          //                       Icon(
          //                         Icons.chevron_right,
          //                         size: 25,
          //                         color: Colors.white54,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   if (widget.reg.isNotEmpty && widget.reg != "None")
          //                     Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) =>
          //                                 timeTableSyllabusModalPaperCreator(
          //                                   heading: widget.reg,
          //                                   size: widget.size,
          //                                   mode: 'Syllabus',
          //                                   reg: widget.reg,
          //                                   branch: widget.branch,
          //                                   id: widget.reg,
          //                                 )));
          //                   else {
          //                     showToastText("Select Your Regulation");
          //                   }
          //                 },
          //               ),
          //             ),
          //             Flexible(
          //               child: InkWell(
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(
          //                       horizontal: 10, vertical: 5),
          //                   margin:
          //                       EdgeInsets.only(bottom: 5, left: 2, top: 10),
          //                   decoration: BoxDecoration(
          //                       color: Colors.white12,
          //                       borderRadius: BorderRadius.circular(10)),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       Row(
          //                         children: [
          //                           Icon(
          //                             Icons.add_box_outlined,
          //                             color: Colors.white54,
          //                             size: widget.size * 25,
          //                           ),
          //                           Text(
          //                             " Model Paper",
          //                             style: TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: widget.size * 22),
          //                           ),
          //                         ],
          //                       ),
          //                       Icon(
          //                         Icons.chevron_right,
          //                         size: 25,
          //                         color: Colors.white54,
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   if (widget.reg.isNotEmpty && widget.reg != "None")
          //                     Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) =>
          //                                 timeTableSyllabusModalPaperCreator(
          //                                   heading: widget.reg,
          //                                   size: widget.size,
          //                                   mode: 'modalPaper',
          //                                   reg: widget.reg,
          //                                   branch: widget.branch,
          //                                   id: widget.reg,
          //                                 )));
          //                   else {
          //                     showToastText("Select Your Regulation");
          //                   }
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          if (isGmail() || isOwner())
            Padding(
              padding:  EdgeInsets.all(Size *8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical:Size * 5, horizontal: Size *8),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(Size *20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size *10, vertical: Size *5),
                            margin:
                            EdgeInsets.only(bottom: Size *5, left:Size * 2, top: Size *10),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(Size *10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white70,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Create Events",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Size *25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: Size *25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => addEvent(
                                      size: widget.size,
                                      branch: widget.branch,
                                    )));
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size *10, vertical: Size *5),
                            margin:
                            EdgeInsets.only(bottom: Size *5, left:Size * 2, top: Size *10),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(Size *10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white70,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Create Regulation by R2_",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Size *25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size: Size *25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                var InputController;
                                return Dialog(
                                  backgroundColor:
                                  Colors.black.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 20)),
                                  elevation: 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(color: Colors.white24),
                                      borderRadius: BorderRadius.circular(
                                          widget.size * 20),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        SizedBox(height: widget.size * 15),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: widget.size * 15),
                                          child: Text(
                                            "Add Regulation by Entering r20",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: widget.size * 18),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: widget.size * 10),
                                          child: TextFieldContainer(
                                            child: TextField(
                                              controller: InputController,
                                              textInputAction:
                                              TextInputAction.next,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: widget.size * 20),
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                  'r2_ <= Enter Regulation Number',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize:
                                                      widget.size * 20)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: widget.size * 5,
                                        ),
                                        Center(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Spacer(),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    border: Border.all(
                                                        color: Colors.white
                                                            .withOpacity(0.3)),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                        widget.size *
                                                            15,
                                                        vertical:
                                                        widget.size *
                                                            5),
                                                    child: Text(
                                                      "Back",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                          widget.size * 14),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                width: widget.size * 10,
                                              ),
                                              InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        widget.size * 25),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                        widget.size *
                                                            15,
                                                        vertical:
                                                        widget.size *
                                                            5),
                                                    child: Text(
                                                      "ADD + ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize:
                                                          widget.size * 14),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    // Prevents dismissing the dialog by tapping outside
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        content: Column(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            CircularProgressIndicator(),
                                                            SizedBox(
                                                                height: 16),
                                                            Text('Creating...'),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                  String reg =
                                                      InputController.text;
                                                  for (int year = 1;
                                                  year <= 4;
                                                  year++) {
                                                    for (int sem = 1;
                                                    sem <= 2;
                                                    sem++) {
                                                      print(
                                                          "${reg.toLowerCase()} $year year $sem sem");
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          widget.branch)
                                                          .doc("regulation")
                                                          .collection(
                                                          "regulationWithYears")
                                                          .doc(
                                                          "${reg.toLowerCase()} $year year $sem sem"
                                                              .substring(
                                                              0, 10))
                                                          .set({
                                                        "id":
                                                        "${reg.toLowerCase()} $year year $sem sem"
                                                            .substring(
                                                            0, 10),
                                                        "syllabus": "",
                                                        "modelPaper": "",
                                                      });
                                                      await createRegulationSem(
                                                          name:
                                                          "${reg.toLowerCase()} $year year $sem sem",
                                                          branch:
                                                          widget.branch);
                                                    }
                                                  }
                                                  messageToOwner(
                                                      "Regulation is Created.\nBy '${fullUserId()}'\n   Regulation : $reg\n **${widget.branch}");
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                width: widget.size * 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: widget.size * 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Text(
                          "Create News",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize:Size * 25),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Size *10, vertical:Size * 5),
                                  margin: EdgeInsets.only(
                                      bottom: Size *5, right: Size *2, top: Size *10),
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(Size *10)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.white70,
                                              size: widget.size * 25,
                                            ),
                                            Expanded(
                                              child: Text(" Flash News",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: Size *25),
                                                  maxLines: 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: Size *25,
                                        color: Colors.white54,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              flashNewsCreator(
                                                branch: widget.branch,
                                                size: widget.size,
                                              )));
                                },
                              ),
                            ),
                            Flexible(
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Size *10, vertical:Size * 5),
                                  margin: EdgeInsets.only(
                                      bottom: Size *5, left: Size *2, top:Size * 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(Size *10)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.add_box_outlined,
                                            color: Colors.white70,
                                            size: widget.size * 25,
                                          ),
                                          Text(
                                            " News",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Size *25),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: Size *25,
                                        color: Colors.white54,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => updateCreator(
                                            branch: widget.branch,
                                            size: widget.size,
                                          )));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: Size *5, horizontal:Size * 8),
                    margin: EdgeInsets.symmetric(vertical: Size *10),

                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(Size *20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Materials",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: Size *25),
                        ),

                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size *10, vertical:Size * 5),
                            margin: EdgeInsets.only(bottom:Size * 5),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(Size *10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white70,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      " Books",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Size *25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size:Size * 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BooksCreator(
                                      branch: widget.branch,
                                    )));
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size *10, vertical:Size * 5),
                            margin: EdgeInsets.only(bottom:Size * 5),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(Size *10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white70,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      "Subjects",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Size *25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size:Size * 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubjectCreator(
                                      branch: widget.branch, size: 1,
                                    )));
                          },
                        ),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Size *10, vertical:Size * 5),
                            margin: EdgeInsets.only(bottom:Size * 5),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(Size *10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white70,
                                      size: widget.size * 25,
                                    ),
                                    Text(
                                      "Subjects",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Size *25),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  size:Size * 25,
                                  color: Colors.white54,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubjectCreator(
                                      branch: widget.branch, size: 1,isSub: false,
                                    )));
                          },
                        ),
                      ],
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //
                  //   decoration: BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: Column(
                  //     children: [
                  //       InkWell(
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 5),
                  //           margin:
                  //           EdgeInsets.only(bottom: 5, right: 2, top: 10),
                  //           decoration: BoxDecoration(
                  //               color: Colors.white12,
                  //               borderRadius: BorderRadius.circular(10)),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Icon(
                  //                     Icons.add_box_outlined,
                  //                     color: Colors.white54,
                  //                     size: widget.size * 25,
                  //                   ),
                  //                   Text(
                  //                     " Time Table",
                  //                     style: TextStyle(
                  //                         color: Colors.white, fontSize: 25),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Icon(
                  //                 Icons.chevron_right,
                  //                 size: 25,
                  //                 color: Colors.white54,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         onTap: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       timeTableSyllabusModalPaperCreator(
                  //                         size: widget.size,
                  //                         mode: 'Time Table',
                  //                         reg: widget.reg,
                  //                         branch: widget.branch,
                  //                       )));
                  //         },
                  //       ),
                  //       InkWell(
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 5),
                  //           margin:
                  //           EdgeInsets.only(bottom: 5, right: 2, top: 10),
                  //           decoration: BoxDecoration(
                  //               color: Colors.white12,
                  //               borderRadius: BorderRadius.circular(10)),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Icon(
                  //                     Icons.add_box_outlined,
                  //                     color: Colors.white54,
                  //                     size: widget.size * 25,
                  //                   ),
                  //                   Text(
                  //                     " Syllabus",
                  //                     style: TextStyle(
                  //                         color: Colors.white, fontSize: 25),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Icon(
                  //                 Icons.chevron_right,
                  //                 size: 25,
                  //                 color: Colors.white54,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         onTap: () {
                  //           if (widget.reg.isNotEmpty && widget.reg != "None")
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         timeTableSyllabusModalPaperCreator(
                  //                           heading: widget.reg,
                  //                           size: widget.size,
                  //                           mode: 'Syllabus',
                  //                           reg: widget.reg,
                  //                           branch: widget.branch,
                  //                           id: widget.reg,
                  //                         )));
                  //           else {
                  //             showToastText("Select Your Regulation");
                  //           }
                  //         },
                  //       ),
                  //       InkWell(
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 10, vertical: 5),
                  //           margin:
                  //           EdgeInsets.only(bottom: 5, left: 2, top: 10),
                  //           decoration: BoxDecoration(
                  //               color: Colors.white12,
                  //               borderRadius: BorderRadius.circular(10)),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Icon(
                  //                     Icons.add_box_outlined,
                  //                     color: Colors.white54,
                  //                     size: widget.size * 25,
                  //                   ),
                  //                   Text(
                  //                     " Model Paper",
                  //                     style: TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: widget.size * 22),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Icon(
                  //                 Icons.chevron_right,
                  //                 size: 25,
                  //                 color: Colors.white54,
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         onTap: () {
                  //           if (widget.reg.isNotEmpty && widget.reg != "None")
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         timeTableSyllabusModalPaperCreator(
                  //                           heading: widget.reg,
                  //                           size: widget.size,
                  //                           mode: 'modalPaper',
                  //                           reg: widget.reg,
                  //                           branch: widget.branch,
                  //                           id: widget.reg,
                  //                         )));
                  //           else {
                  //             showToastText("Select Your Regulation");
                  //           }
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // )

                ],
              ),
            ),
        ],
      ),
    );
  }
}
