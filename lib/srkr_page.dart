import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class SRKRPage extends StatefulWidget {
  const SRKRPage({Key? key}) : super(key: key);

  @override
  State<SRKRPage> createState() => _SRKRPageState();
}

class _SRKRPageState extends State<SRKRPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('SRKR Web (Beta)')),
      body: Container(


      ),
    );
  }
}
