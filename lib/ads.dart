import 'package:flutter/cupertino.dart';

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'functions.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class CustomAdsBannerForPdfs extends StatefulWidget {
  CustomAdsBannerForPdfs();

  @override
  _CustomAdsBannerForPdfsState createState() => _CustomAdsBannerForPdfsState();
}

class _CustomAdsBannerForPdfsState extends State<CustomAdsBannerForPdfs> {
  BannerAd? _bannerAd; // Make BannerAd nullable
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      _loadBannerAd();
    }).catchError((error) {
      print('Failed to initialize MobileAds: $error');
    });
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdPdfs.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd!.load().catchError((error) {
      print('Failed to load banner ad: $error');
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Use null-aware operator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isBannerAdLoaded && _bannerAd != null
          ? _bannerAd!.size.height.toDouble()
          : 50,
      child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : SizedBox(),
    );
  }
}


class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/2545378412';
    }else {
      return 'ca-app-pub-7097300908994281/3170238605';
    }
  }
}
class AdPdfs {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/3144978362';
    }else {
      return 'ca-app-pub-7097300908994281/3510865679';
    }
  }
}
HomePageAd(){
  late final RewardedAd rewardedAd;
  void _setFullScreenContentCallback() {
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      //when ad  shows fullscreen
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print("$ad onAdShowedFullScreenContent"),
      //when ad dismissed by user
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");

        //dispose the dismissed ad
        ad.dispose();
      },
      //when ad fails to show
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad  onAdFailedToShowFullScreenContent: $error ");
        //dispose the failed ad
        ad.dispose();
      },

      //when impression is detected
      onAdImpression: (RewardedAd ad) => print("$ad Impression occured"),
    );
  }

  Future<void> _showRewardedAd() async {
    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          num amount = rewardItem.amount;
          showToastText("You earned: $amount");
        });
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdVideo.bannerAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
        },
        onAdLoaded: (RewardedAd ad) async {
          print("$ad loaded");
          showToastText("Ad loaded");
          rewardedAd = ad;
          _setFullScreenContentCallback();
          await _showRewardedAd();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('lastOpenAdTime', DateTime.now().millisecondsSinceEpoch);
        },
      ),
    );
  }


  double remainingTime = 0;


  Future<void> _checkImageOpenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? lastOpenTime = prefs.getInt('lastOpenAdTime');

    if (lastOpenTime == null) {
      _loadRewardedAd();
    } else {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = (currentTime - lastOpenTime) ~/ 1000;

      if (difference >= 259200) {
        _loadRewardedAd();
      } else {
        if (difference >= 10800) {
          remainingTime = ((10800 - difference) / 60)/60;
          showToastText("Video Ad with in ${remainingTime.toInt()}H");
        }
      
      }
    }
  }
  _checkImageOpenStatus();
}