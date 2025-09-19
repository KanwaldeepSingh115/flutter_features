import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerTestAds extends StatefulWidget {
  const BannerTestAds({super.key});

  @override
  State<BannerTestAds> createState() => _BannerTestAdsState();
}

class _BannerTestAdsState extends State<BannerTestAds> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },

        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Error: $error');
        },
      ),
    );

    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAdLoaded
        ? Container(
            alignment: Alignment.center,
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          )
        : SizedBox();
  }
}
