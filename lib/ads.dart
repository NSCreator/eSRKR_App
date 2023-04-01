import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdsBanner extends StatefulWidget {
  @override
  _CustomAdsBannerState createState() => _CustomAdsBannerState();
}

class _CustomAdsBannerState extends State<CustomAdsBanner> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3558812501803195/5706094921", // Replace with your ad unit id
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
