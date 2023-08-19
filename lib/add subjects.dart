// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:srkr_study_app/functins.dart';
import 'ads.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final int defaultPage;
  final double size;

  const PdfViewerPage(
      {Key? key,
      required this.pdfUrl,
      this.defaultPage = 0,
      required this.size})
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
                  borderRadius: BorderRadius.circular(widget.size * 20)),
              elevation: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(widget.size * 20),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: widget.size * 15),
                    Padding(
                      padding: EdgeInsets.only(left: widget.size * 15),
                      child: Text(
                        "Press Yes to go back",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: widget.size * 18),
                      ),
                    ),
                    SizedBox(
                      height: widget.size * 5,
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
                                  color: Colors.redAccent,
                                  fontSize: widget.size * 20,
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
                                  color: Colors.greenAccent,
                                  fontSize: widget.size * 20,
                                  fontWeight: FontWeight.w600),
                            ),
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
        return shouldPop;
      },
      child: Scaffold(
          body: Stack(
            children: [
              isLoading && isReady
                  ? Center(child: CircularProgressIndicator())
                  : PDFView(
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
                      onViewCreated: (PDFViewController pdfViewController) {
                        Completer<PDFViewController> controller =
                            Completer<PDFViewController>();
                        controller.complete(pdfViewController);
                      },
                    ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomAdsBannerForPdfs()),
              Positioned(
                left: 0,
                top: widget.size * 50,
                child: backButton(
                  color: Colors.black,
                  size: widget.size,
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: widget.size * 35),
            child: Container(
                height: isExpand ? widget.size * 130 : widget.size * 40,
                width: widget.size * 40,
                decoration: BoxDecoration(
                  color: isNightMode
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(widget.size * 16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: widget.size * 3,
                          top: widget.size * 3,
                          right: widget.size * 3),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isScrolling)
                              Text(
                                "${currentPage! + 1}",
                                style: TextStyle(
                                    fontSize: widget.size * 20,
                                    fontWeight: FontWeight.w600,
                                    color: isNightMode
                                        ? Colors.black
                                        : Colors.white),
                              )
                            else
                              Icon(
                                  isExpand
                                      ? Icons.expand_more
                                      : Icons.more_horiz,
                                  size: widget.size * 30,
                                  color: isNightMode
                                      ? Colors.black
                                      : Colors.white),
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
                            color: Colors.white,
                            fontSize: widget.size * 10,
                            fontWeight: FontWeight.w600),
                      ),
                    if (isExpand)
                      InkWell(
                        child: Icon(
                          isSwipeHorizontal
                              ? Icons.swap_vert
                              : Icons.swap_horiz,
                          size: widget.size * 30,
                          color: isNightMode ? Colors.black : Colors.white,
                        ),
                        onTap: () {
                          isSwipeHorizontal = !isSwipeHorizontal;
                          _reloadPage();
                        },
                      ),
                    if (isExpand)
                      Padding(
                        padding: EdgeInsets.all(widget.size * 3.0),
                        child: InkWell(
                            child: Icon(
                                isNightMode
                                    ? Icons.wb_sunny_outlined
                                    : Icons.nightlight_round_rounded,
                                size: widget.size * 30,
                                color:
                                    isNightMode ? Colors.black : Colors.white),
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
