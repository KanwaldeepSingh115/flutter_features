import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_services/Test/bannerad_test.dart';
import 'package:test_services/Test/second_page.dart';

class AdsHomePage extends StatefulWidget {
  const AdsHomePage({super.key});

  @override
  State<AdsHomePage> createState() => _AdsHomePageState();
}

class _AdsHomePageState extends State<AdsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Ads Test'),centerTitle: true,),
      body: Column(
        spacing: 10,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Lottie.asset('assets/googleAds.json'),
          ),

          Text(
            'Welcome To Mobile Ads',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdsSecondPage()),
              );
            },
            icon: Icon(Icons.arrow_right_alt,size: 35,),
          ),
          Spacer(),
        ],
      ),
      bottomNavigationBar: BannerTestAds(),
    );
  }
}
