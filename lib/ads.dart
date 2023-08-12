import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';
import 'package:http/http.dart' as http;
class CustomAdsBannerForPdfs extends StatefulWidget {
  @override
  _CustomAdsBannerForPdfsState createState() => _CustomAdsBannerForPdfsState();
}

class _CustomAdsBannerForPdfsState extends State<CustomAdsBannerForPdfs> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId:AdHelper.bannerAdUnitId, // Replace with your ad unit id
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _isBannerAdLoaded ? _bannerAd!.size.width.toDouble() : 0,
      height: _isBannerAdLoaded ? _bannerAd!.size.height.toDouble() : 0,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/1371419626';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7097300908994281/4786642104';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}

class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/7894809729';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7097300908994281/8849115979';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double _downloadProgress = 0.0; // Initialize with 0% progress

  // Simulating a data download and write process
  Future<void> _downloadAndWriteData() async {
    final url = 'https://example.com/your_file.zip'; // Replace with your download URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final file = File('/path_to_your_file/your_file.zip'); // Replace with your desired file path

      final totalBytes = response.contentLength ?? 0;

      // Download and write data in chunks
      var downloadedBytes = 0;
      final responseBytes = response.bodyBytes;
      for (var chunk in responseBytes) {
        file.writeAsBytesSync([chunk], mode: FileMode.append);
        downloadedBytes += 1;
        _updateProgress(downloadedBytes, totalBytes);
      }

      setState(() {
        _downloadProgress = 1.0; // Set progress to 100% when download is complete
      });
    }
  }

  // Update progress based on downloadedBytes and totalBytes
  void _updateProgress(int downloadedBytes, int totalBytes) {
    setState(() {
      _downloadProgress = downloadedBytes / totalBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              value: _downloadProgress,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text('${(_downloadProgress * 100).toStringAsFixed(2)}%'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _downloadAndWriteData,
              child: Text('Start Download'),
            ),
          ],
        ),
      ),
    );
  }
}

