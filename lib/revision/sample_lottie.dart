import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieSample extends StatelessWidget {
  const LottieSample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Lottie.asset('assets/loader.json'))),
    );
  }
}
