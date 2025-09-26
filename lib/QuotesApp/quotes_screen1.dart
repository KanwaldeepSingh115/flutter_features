import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_practice/QuotesApp/quote_model1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Quotes Service',
      initialNotificationContent: 'Fetching quotes...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Welcome to Motivational Quotes App",
      content: "Showcasing best quotes for you every 2 hours...",
    );
  }

  List<Map<String, String>> quotesList = [];
  int currentIndex = 0;

  
  Future<void> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.paperquotes.com/apiv1/quotes/?format=json&limit=50&tags=motivation'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final results = json['results'] as List;
        quotesList = results
            .map((e) => {
                  "quote": e['quote'] as String,
                  "author": e['author'] as String? ?? "Unknown"
                })
            .toList();
        currentIndex = 0;
      }
    } catch (e) {
      debugPrint("Error fetching background quotes: $e");
    }
  }

  
  fetchQuotes();

  
  Timer.periodic(const Duration(hours: 2), (timer) async {
    if (quotesList.isEmpty) {
      await fetchQuotes();
    }

    if (quotesList.isNotEmpty) {
      final item = quotesList[currentIndex];
      currentIndex = (currentIndex + 1) % quotesList.length;

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: item["quote"]!,
          content: item["author"]!,
        );
      }
    }
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
  });
}


class QuotesScreen1 extends StatefulWidget {
  const QuotesScreen1({super.key});

  @override
  State<QuotesScreen1> createState() => _QuotesScreen1State();
}

class _QuotesScreen1State extends State<QuotesScreen1> {
  QuotesModel1? quotesModell;
  List<String> _quotes = [];
  List<String> _authors = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuotes();
    requestNotificationPermission();
    initializeService();
  }

  Future<void> _fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(
          'http://api.paperquotes.com/apiv1/quotes/?format=json&limit=20&tags=motivation'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final quotesModel = QuotesModel1.fromJson(json);

        setState(() {
          quotesModell = quotesModel;
          _quotes = quotesModel.results.map((e) => e.quote).toList();
          _authors = quotesModel.results.map((e) => e.author).toList();
          _currentIndex = 0;
        });
      }
    } catch (e) {
      debugPrint("Error fetching quotes for UI: $e");
    }
  }

  void _showNextQuote() {
    setState(() {
      if (_quotes.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % _quotes.length;
      }
    });
  }

  Future<void> _stopService() async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Background service stopped"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = _quotes.isEmpty ? "" : _quotes[_currentIndex];
    final currentAuthor = _authors.isEmpty ? "" : _authors[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
         
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgimage.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.stop_circle, color: Colors.teal, size: 32),
              tooltip: "Stop Service",
              onPressed: _stopService,
            ),
          ),

          
          Center(
            child: currentQuote.isEmpty
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentQuote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentAuthor.isEmpty ? "Unknown" : '- $currentAuthor',
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNextQuote,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.refresh, color: Colors.tealAccent),
      ),
    );
  }
}
