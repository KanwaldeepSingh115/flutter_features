import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class UrlLauncherExample extends StatelessWidget {
  const UrlLauncherExample({super.key});

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("URL Launcher Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () =>
                  _launchUrl(Uri(scheme: "tel", path: "+918568003744")),
              child: const Text("Call"),
            ),
            ElevatedButton(
              onPressed: () =>
                  _launchUrl(Uri(scheme: "sms", path: "+918568003744")),
              child: const Text("Send SMS"),
            ),
            ElevatedButton(
              onPressed: () => _launchUrl(Uri(
                scheme: "mailto",
                path: "kanwalshehry@gmail.com",
                queryParameters: {"subject": "Test Email", "body": "Hello!"},
              )),
              child: const Text("Send Email"),
            ),
            ElevatedButton(
              onPressed: () =>
                  _launchUrl(Uri.parse("file:/C:/Users/ASUS/Documents")),
              child: const Text("Open File/Folder"),
            ),
          ],
        ),
      ),
    );
  }
}

