import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd01 extends StatefulWidget {
  const CustomBannerAd01({Key? key}) : super(key: key);

  @override
  State<CustomBannerAd01> createState() => _CustomBannerAd01State();
}

class _CustomBannerAd01State extends State<CustomBannerAd01> {
  BannerAd? bannerAd;
  bool isBannerAdLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-7097300908994281/6941213951",
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        print("Ad Failed to Load");
        ad.dispose();
      }, onAdLoaded: (ad) {
        print("Ad Loaded");
        setState(() {
          isBannerAdLoaded = true;
        });
      }),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerAdLoaded
        ? SizedBox(
            width: double.infinity,
            height: 50,
            child: AdWidget(
              ad: bannerAd!,
            ),
          )
        : SizedBox();
  }
}

