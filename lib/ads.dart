// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'dart:io';

//
// class CustomAdsBannerForPdfs extends StatefulWidget {
//   double size;
//   CustomAdsBannerForPdfs({required this.size});
//   @override
//   _CustomAdsBannerForPdfsState createState() => _CustomAdsBannerForPdfsState();
// }
//
// class _CustomAdsBannerForPdfsState extends State<CustomAdsBannerForPdfs> {
//   late BannerAd _bannerAd;
//   bool _isBannerAdLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     MobileAds.instance.initialize();
//
//     _bannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.banner,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           print('Ad loaded.');
//           setState(() {
//             _isBannerAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           print('Ad failed to load: $error');
//         },
//       ),
//     );
//
//     _bannerAd.load();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: _isBannerAdLoaded ? _bannerAd.size.height.toDouble() :widget.size *  50,
//       child: AdWidget(ad: _bannerAd),
//     );
//   }
// }

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/1371419626';
    } else {
      return 'ca-app-pub-7097300908994281/3510865679';
    }
  }
}

class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/7894809729';
    }else {
      return 'ca-app-pub-7097300908994281/8849115979';
    }
  }
}

