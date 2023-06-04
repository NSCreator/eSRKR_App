// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'ads.dart';
import 'functins.dart';

class unseenImages extends StatefulWidget {
  final String branch;
  const unseenImages({Key? key, required this.branch}) : super(key: key);
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
      _imagePaths = files
          .where((file) =>
              file.path.endsWith('.png') ||
              file.path.endsWith('.jpg') ||
              file.path.endsWith('.jpeg') ||
              file.path.endsWith('.image'))
          .map((file) => file.path)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
              fit: BoxFit.fill)),
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Saved PDFS (In App)",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.orange),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            ".pdf .txt .ppt etc.,",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path: "pdfs",
                                  heading: 'Saved .pdf .txt .ppt',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Saved Images (In App)",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.orange),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Updates Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path:
                                      "${widget.branch.toLowerCase()}_updates",
                                  heading: 'Saved Updates',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "${widget.branch} News Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path: "${widget.branch.toLowerCase()}_news",
                                  heading: 'Saved News',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Time Table Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path:
                                      "${widget.branch.toLowerCase()}_timetable",
                                  heading: 'Time Table Images',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Subject Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path:
                                      "${widget.branch.toLowerCase()}_subjects",
                                  heading: 'Saved Subjects',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Lab Subject Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path:
                                      "${widget.branch.toLowerCase()}_labsubjects",
                                  heading: 'Saved Lab Subjects',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: InkWell(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(143, 17, 17, 1),
                              Color.fromRGBO(212, 38, 38, 1),
                              Color.fromRGBO(212, 55, 38, 1),
                              Color.fromRGBO(232, 86, 46, 1),
                              Color.fromRGBO(232, 102, 46, 1)
                            ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Books Images",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Images(
                                  path: "${widget.branch.toLowerCase()}_books",
                                  heading: 'Saved Books',
                                )));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "You Saved Images",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.orangeAccent),
                ),
              ),
              if (_imagePaths.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _imagePaths.length,
                  itemBuilder: (BuildContext context, int index) => Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          height: 65,
                          child: VerticalDivider(
                            thickness: 3,
                            color: Colors.orangeAccent,
                          )),
                      Container(
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(
                                File(_imagePaths[index]),
                                // fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              _imagePaths[index].split("/").last,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    " Delete",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              final file = File(_imagePaths[index]);
                              if (file.existsSync()) {
                                await file.delete();
                              }
                              showToastText(
                                  "${_imagePaths[index].split("/").last} has been deleted");
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
    ));
  }
}

class Images extends StatefulWidget {
  String path = "";
  String heading;

  Images({Key? key, required this.path, required this.heading})
      : super(key: key);

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
      _imagePaths = files
          .where((file) =>
              file.path.endsWith('.png') ||
              file.path.endsWith('.pdf') ||
              file.path.endsWith('.firebase') ||
              file.path.endsWith('.jpg') ||
              file.path.endsWith('.jpeg') ||
              file.path.endsWith('.image'))
          .map((file) => file.path)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://i.pinimg.com/736x/01/c7/f7/01c7f72511cc6ce7858e65b45d4f8c9c.jpg"),
                fit: BoxFit.fill)),
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.heading,
                  style: TextStyle(color: Colors.orange, fontSize: 35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 25),
                child: Text(
                  "Note : After deleting the images restart the app",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
              if (_imagePaths.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ListView.builder(
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
                                  image: DecorationImage(
                                    image: FileImage(
                                      File(_imagePaths[index]),
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    _imagePaths[index].split("/").last,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          " Delete",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    final file = File(_imagePaths[index]);
                                    if (file.existsSync()) {
                                      await file.delete();
                                    }
                                    showToastText(
                                        "${_imagePaths[index].split("/").last} has been deleted");
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (widget.path == "pdfs")
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewerPage(pdfUrl: _imagePaths[index])));
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

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

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
    return Scaffold(
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
                      _controller.complete(pdfViewController);
                    },
                  ),
            Align(
                alignment: Alignment.bottomCenter,
                child: CustomAdsBannerForPdfs()),
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
                              color: isNightMode ? Colors.black : Colors.white,
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
                              color: isNightMode ? Colors.black : Colors.white,
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
                              color: isNightMode ? Colors.black : Colors.white,
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
          padding: const EdgeInsets.only(bottom: 30),
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
        ));
  }
}
