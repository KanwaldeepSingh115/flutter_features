import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_practice/revision/demo_apimodel.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiDemo extends StatefulWidget {
  const ApiDemo({super.key});

  @override
  State<ApiDemo> createState() => _ApiDemoState();
}

class _ApiDemoState extends State<ApiDemo> {
  late Future<NewsApiModel> futurePosts;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _autoSwipeTimer;
  bool _isPaused = false;
  double _seeAgainOpacity = 0.0;

  Future<NewsApiModel> fetchPosts() async {
    final response = await http.get(
      Uri.parse(
        'https://newsapi.org/v2/everything?q=fitness&from=2025-08-05&language=en&sortBy=publishedAt&apiKey=dd0541af3edc46d7add05e5ba3e11162',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return NewsApiModel.fromJson(json);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not launch URL")));
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  void _startAutoSwipe(int itemCount) {
    _autoSwipeTimer?.cancel();
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && itemCount > 0 && !_isPaused) {
        int nextPage = _currentPage + 1;

        if (nextPage >= itemCount) {
          setState(() {
            _isPaused = true;
            _seeAgainOpacity = 1.0;
          });
          _autoSwipeTimer?.cancel();
          return;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('News Api'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<NewsApiModel>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.articles.isEmpty) {
            return const Center(child: Text('No data exists!'));
          } else {
            final articles = snapshot.data!.articles;

            if (!_isPaused &&
                (_autoSwipeTimer == null || !_autoSwipeTimer!.isActive)) {
              _startAutoSwipe(articles.length);
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        if (index == articles.length - 1) {
                          _isPaused = true;
                          _seeAgainOpacity = 1.0;
                        }
                      });
                    },

                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final myarticle = articles[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[900],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              if (myarticle.urlToImage != null &&
                                  myarticle.urlToImage!.isNotEmpty)
                                Positioned.fill(
                                  child: Image.network(
                                    myarticle.urlToImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            myarticle.source.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          myarticle.publishedAt
                                              .split("T")
                                              .first,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      myarticle.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      myarticle.description ?? '',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          () => _launchURL(myarticle.url),
                                      child: const Text(
                                        "Read More",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                Builder(
                  builder: (context) {
                    int totalDots = articles.length;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: totalDots,
                          onDotClicked: (index) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          effect: ScrollingDotsEffect(
                            maxVisibleDots: 7,
                            activeDotColor: Colors.redAccent,
                            dotColor: Colors.grey,
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 6,
                            fixedCenter: true,
                          ),
                        ),

                        if (_isPaused && _currentPage == totalDots - 1) ...[
                          const SizedBox(width: 8),
                          const SizedBox(width: 8),
                          AnimatedOpacity(
                            opacity: _seeAgainOpacity,
                            duration: const Duration(milliseconds: 400),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _seeAgainOpacity = 0.0;
                                  _isPaused = false;
                                  _currentPage = -1;
                                });

                                _startAutoSwipe(totalDots);
                              },

                              child: const Text("See Again"),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          }
        },
      ),
    );
  }
}
