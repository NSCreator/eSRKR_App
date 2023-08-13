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

  const PdfViewerPage({Key? key, required this.pdfUrl, this.defaultPage = 0})
      : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? currentPage = 0;
  late bool isEnableSwipe = true;
  late bool isExpand = false;
  late bool isPageSnap = false;
  bool isReady = false;
  int? pages = 0;
  late bool l1 = false;
  late bool l2 = false;
  late bool isNightMode = false;
  late bool isScrolling = false;
  late bool isSwipeHorizontal = false;
  late bool isAutoSpacing = false;
  String errorMessage = '';

  Timer? _timer;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.defaultPage;
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer here
    super.dispose();
  }

  on() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        l1 = true;
      });
    });
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        l2 = true;
      });
    });
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
    super.build(context);
    return WillPopScope(
      onWillPop: () async {


        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to go back?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
          body: Stack(

            children: [
              isLoading && isReady
                  ? Center(child: CircularProgressIndicator())
                  : PDFView(
                      filePath: widget.pdfUrl,
                      enableSwipe: isEnableSwipe,
                      pageSnap: isPageSnap,
                      defaultPage: currentPage as int,
                      swipeHorizontal: isSwipeHorizontal,
                      autoSpacing: isAutoSpacing,
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

                top: 50,
                child: backButton(color: Colors.black,size:size(context) ,),
              ),
              if (isExpand)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: isNightMode
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              child: Icon(
                                isEnableSwipe
                                    ? Icons.lock_outline
                                    : Icons.lock_open,
                                color:
                                    isNightMode ? Colors.black : Colors.white,
                              ),
                              onTap: () {
                                isEnableSwipe = !isEnableSwipe;
                                _reloadPage();
                              },
                            ),
                            InkWell(
                              child: Icon(
                                isPageSnap
                                    ? Icons.view_carousel
                                    : Icons.view_carousel_outlined,
                                color:
                                    isNightMode ? Colors.black : Colors.white,
                              ),
                              onTap: () {
                                isPageSnap = !isPageSnap;
                                _reloadPage();
                              },
                            ),
                            InkWell(
                              child: Icon(
                                isSwipeHorizontal
                                    ? Icons.swap_vert
                                    : Icons.swap_horiz,
                                color:
                                    isNightMode ? Colors.black : Colors.white,
                              ),
                              onTap: () {
                                isSwipeHorizontal = !isSwipeHorizontal;
                                _reloadPage();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: AnimatedContainer(
                height: isExpand ? 175 : 51,
                width: 51,
                decoration: BoxDecoration(
                  color: isNightMode
                      ? Colors.white.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(isExpand ? 25 : 15),
                ),
                duration: Duration(milliseconds: isExpand ? 300 : 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3, top: 3, right: 3),
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isScrolling)
                              Text(
                                "${currentPage! + 1}",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: isNightMode
                                        ? Colors.black
                                        : Colors.white),
                              )
                            else
                              Icon(
                                  isExpand ? Icons.expand_more : Icons.more_horiz,
                                  size: 45,
                                  color:
                                      isNightMode ? Colors.black : Colors.white),
                          ],
                        ),
                        onTap: () {
                          if (isExpand) {
                            isExpand = false;
                            l1 = false;
                            l2 = false;
                          } else {
                            isExpand = true;
                            on();
                          }
                          setState(() {
                            isExpand;
                            l1;
                            l2;
                          });
                        },
                      ),
                    ),
                    if (l1)
                      Text(
                        "Pages : $pages",
                        style: TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    if (l1)
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                          child: Icon(
                              MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? Icons.rotate_90_degrees_ccw
                                  : Icons.rotate_90_degrees_cw,
                              size: 35,
                              color: isNightMode ? Colors.black : Colors.white),
                          onTap: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.landscapeLeft]);
                            } else {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            }
                          },
                        ),
                      ),
                    if (l2)
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: InkWell(
                            child: Icon(
                                isNightMode
                                    ? Icons.wb_sunny_outlined
                                    : Icons.nightlight_round_rounded,
                                size: 35,
                                color: isNightMode ? Colors.black : Colors.white),
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
