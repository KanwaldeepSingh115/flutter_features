import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'banner_widget.dart';

class MobileAdsPage extends StatefulWidget {
  const MobileAdsPage({super.key});

  @override
  State<MobileAdsPage> createState() => _MobileAdsPageState();
}

class _MobileAdsPageState extends State<MobileAdsPage> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mobile Ads")),

      body: Column(
        children: [
          TextButton(
            onPressed: _showInterstitialAd,
            child: Text("Show interstitial ad"),
          ),
          Spacer()
        ],
      ),

      bottomNavigationBar: BannerAdWidget(), // Always visible at bottom
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial failed to load: $error');
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }
}
