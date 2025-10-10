import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Webview extends StatefulWidget {
  const Webview({super.key});

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri("https://www.bugatti.com/")),

        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            supportZoom: true,
          ),
        ),
        onWebViewCreated: (controller) => webViewController = controller,
      ),
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
          return false;
        }
        return true;
      },
    );
  }
}
