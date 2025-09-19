
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:test_services/Test/bannerad_test.dart';
import 'package:test_services/Test/home_page.dart';

class AdsSecondPage extends StatefulWidget {
  const AdsSecondPage({super.key});

  @override
  State<AdsSecondPage> createState() => _AdsSecondPageState();
}

class _AdsSecondPageState extends State<AdsSecondPage> {
  Timer? delayTimer;
  InterstitialAd? interstitialAd;
  bool onClick = false;

  @override
  void initState() {
    loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Error: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Ads Test'), centerTitle: true),
      body: Center(
        child: Column(
          spacing: 10,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Lottie.asset('assets/thanks.json'),
            ),
            Text(
              'Thanks for showing interest in us!\nNavigate Back Home to See Ads',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            IconButton(
              onPressed: () {
                onClick = true;
                if (onClick) {
                  showInterstitialAd();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdsHomePage()),
                    );
                    
                }
              },
              icon: Icon(Icons.home, size: 35),
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BannerTestAds(),
    );
  }
}
