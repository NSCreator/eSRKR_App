// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:srkr_study_app/functions.dart';

import 'ads.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final int defaultPage;


  const PdfViewerPage(
      {Key? key,
      required this.pdfUrl,
      this.defaultPage = 0})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  int? currentPage = 0;
  late bool isExpand = false;
  bool isReady = false;
  int? pages = 0;
  late bool isNightMode = false;
  late bool isScrolling = false;
  late bool isSwipeHorizontal = false;
  late PDFViewController pdfController;
  Timer? _timer;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.defaultPage;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void isScrollingThePage() {
    if (mounted) {
      setState(() {
        isScrolling = true;
      });

      _timer?.cancel();

      _timer = Timer(Duration(seconds: 2), () {
        setState(() {
          isScrolling = false;
        });
      });
    }
  }

  void _reloadPage() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(  20)),
              elevation: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors. black54,
                  border: Border.all(color: Colors. black26),
                  borderRadius: BorderRadius.circular(  20),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height:   15),
                    Padding(
                      padding: EdgeInsets.only(left:   15),
                      child: Text(
                        "Press Yes to go back",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize:   18),
                      ),
                    ),
                    SizedBox(
                      height:   5,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:   20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:   20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height:   10,
                    ),
                  ],
                ),
              ),
            );
          },
        );
        return shouldPop;
      },
      child: Scaffold(
          body: Stack(
            children: [
              isLoading && isReady
                  ? Center(child: CircularProgressIndicator())
                  : PDFView(
                pageSnap:false,
                      fitPolicy: FitPolicy.BOTH,
                fitEachPage:false,
                      filePath: widget.pdfUrl,
                      defaultPage: currentPage as int,
                      swipeHorizontal: isSwipeHorizontal,
                      pageFling: false,
                      nightMode: isNightMode,
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onPageChanged: (page, total) {
                        setState(() {
                          currentPage = page;
                          isScrolling = true;
                        });
                        isScrollingThePage();
                      },
                      onError: (error) {
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                      // onViewCreated: (PDFViewController pdfViewController) {
                      //   Completer<PDFViewController> controller =
                      //       Completer<PDFViewController>();
                      //   controller.complete(pdfViewController);
                      // },
                onViewCreated: (PDFViewController pdfViewController) {
                  pdfController = pdfViewController; // Assign the controller
                  // Enable side-scrolling by setting scroll direction to horizontal
                 
                },
                    ),
              // if(!isGmail())Align(
              //     alignment: Alignment.bottomCenter,
              //     child: CustomAdsBannerForPdfs(  )),
              Positioned(
                left: 0,
                top:   50,
                child: backButton(
                  color: Colors.black,child: SizedBox(width:   45,)
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom:   35),
            child: Container(
                height: isExpand ?   130 :   40,
                width:   40,
                decoration: BoxDecoration(
                  color: isNightMode
                      ? Colors. black.withOpacity(0.5)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(  16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left:   3,
                          top:   3,
                          right:   3),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isScrolling)
                              Text(
                                "${currentPage! + 1}",
                                style: TextStyle(
                                    fontSize:   20,
                                    fontWeight: FontWeight.w600,
                                    color: isNightMode
                                        ? Colors.black
                                        : Colors. black),
                              )
                            else
                              Icon(
                                  isExpand
                                      ? Icons.expand_more
                                      : Icons.more_horiz,
                                  size:   30,
                                  color: isNightMode
                                      ? Colors.black
                                      : Colors. black),
                          ],
                        ),
                        onTap: () {
                          if (isExpand) {
                            isExpand = false;

                          } else {
                            isExpand = true;
                          }
                          setState(() {
                            isExpand;
                          });
                        },
                      ),
                    ),
                    if (isExpand)
                      Text(
                        "P : ${currentPage! + 1}/$pages",
                        style: TextStyle(
                            color: Colors. black,
                            fontSize:   10,
                            fontWeight: FontWeight.w600),
                      ),
                    if (isExpand)
                      InkWell(
                        child: Icon(
                          isSwipeHorizontal
                              ? Icons.swap_vert
                              : Icons.swap_horiz,
                          size:   30,
                          color: isNightMode ? Colors.black : Colors. black,
                        ),
                        onTap: () {
                          isSwipeHorizontal = !isSwipeHorizontal;
                          _reloadPage();
                        },
                      ),
                    if (isExpand)
                      Padding(
                        padding: EdgeInsets.all(  3.0),
                        child: InkWell(
                            child: Icon(
                                isNightMode
                                    ? Icons.wb_sunny_outlined
                                    : Icons.nightlight_round_rounded,
                                size:   30,
                                color:
                                    isNightMode ? Colors.black : Colors. black),
                            onTap: () {
                              isNightMode = !isNightMode;
                              _reloadPage();
                            }),
                      ),
                  ],
                )),
          )),
    );
  }
}
