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

  const PdfViewerPage({Key? key, required this.pdfUrl, this.defaultPage = 0})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  int? currentPage = 0;

  bool isReady = false;
  int? pages = 0;
  late bool isNightMode = false;

  late bool isSwipeHorizontal = false;
  late PDFViewController pdfController;

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

  bool _isBackPressedOnce = false;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (_isBackPressedOnce) {
          return Future.value(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          _isBackPressedOnce = true;
          Timer(Duration(seconds: 2), () {
            _isBackPressedOnce = false;
          });
          return Future.value(false);
        }
      },
      child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                isLoading && isReady
                    ? Center(child: CircularProgressIndicator())
                    : PDFView(
                        autoSpacing: false,
                        //
                        pageSnap: false,
                        fitPolicy: FitPolicy.BOTH,
                        fitEachPage: false,

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
                          });
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
                          pdfController =
                              pdfViewController; // Assign the controller
                          // Enable side-scrolling by setting scroll direction to horizontal
                        },
                      ),
                if ((!isGmail())&&(!isOwner())&&
                    MediaQuery.of(context).orientation == Orientation.portrait)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomAdsBannerForPdfs(),
                  ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: backButton(),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: PopupMenuButton(
                    child: Icon(
                      Icons.more_vert,
                      color: isNightMode ? Colors.white : Colors.black,
                      size: 25,
                    ),
                    // Callback that sets the selected popup menu item.
                    onSelected: (item) async {
                      if (item == "isNightMode") {
                        isNightMode = !isNightMode;
                        _reloadPage();
                      }
                      if (item == "isSwipeHorizontal") {
                        isSwipeHorizontal = !isSwipeHorizontal;
                        _reloadPage();
                      }
                      if (item == "Last Page") {
                        currentPage = (pages! - 1);
                        _reloadPage();
                      }
                      if (item == "First Page") {
                        currentPage = 0;
                        _reloadPage();
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        value: "First Page",
                        child: Text('First Page'),
                      ),
                      PopupMenuItem(
                        value: "isNightMode",
                        child: Text(
                            isNightMode ? "Night Mode OFF" : 'Night Mode On'),
                      ),
                      PopupMenuItem(
                        value: "isSwipeHorizontal",
                        child: Text(isSwipeHorizontal
                            ? "Swipe Vertical"
                            : 'Swipe Horizontal'),
                      ),
                      PopupMenuItem(
                        value: "Last Page",
                        child: Text("Last Page"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Text(
            "${currentPage! + 1}/$pages",
            style: TextStyle(
                color: isNightMode ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          )),
    );
  }
}
