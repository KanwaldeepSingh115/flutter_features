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
          ],
        ),
      ),
    );
  }
}

// class UrlLauncherExample extends StatelessWidget {
//   const UrlLauncherExample({super.key});

//   Future<void> _launchUrl(Uri uri) async {
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $uri';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("URL Launcher Example")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () =>
//                   _launchUrl(Uri(scheme: "tel", path: "+918568003744")),
//               child: const Text("Call"),
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   _launchUrl(Uri(scheme: "sms", path: "+918568003744")),
//               child: const Text("SMS"),
//             ),
//             ElevatedButton(
//               onPressed: () => _launchUrl(
//                 Uri(
//                   scheme: "mailto",
//                   path: "kanwalshehry@gmail.com",
//                   queryParameters: {"subject": "Hello", "body": "Test email"},
//                 ),
//               ),
//               child: const Text("Email"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class UrlLauncherExample extends StatelessWidget {
// //   const UrlLauncherExample({super.key});

// //   Future<void> _launchUrl(String url) async {
// //     final Uri uri = Uri.parse(url);

// //     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
// //       throw 'Could not launch $url';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("URL Launcher Example")),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             /// Call
// //             TextButton(
// //               onPressed: () async {
// //                 const tel = "tel:+918568003744";
// //                 await _launchUrl(tel);
// //               },
// //               child: const CustomWidget(
// //                 icon: Icons.call,
// //                 label: 'Call a phone\nnumber',
// //               ),
// //             ),

// //             /// SMS
// //             TextButton(
// //               onPressed: () async {
// //                 const sms = "sms:+918568003744";
// //                 await _launchUrl(sms);
// //               },
// //               child: const CustomWidget(
// //                 icon: Icons.textsms,
// //                 label: 'Send an SMS',
// //               ),
// //             ),

// //             /// Email
// //             TextButton(
// //               onPressed: () async {
// //                 const email =
// //                     "mailto:kanwalshehry@gmail.com?subject=This is a test email&body=This is a test email body";
// //                 await _launchUrl(email);
// //               },
// //               child: const CustomWidget(
// //                 icon: Icons.forward_to_inbox,
// //                 label: 'Send an email',
// //               ),
// //             ),

            
// //             TextButton(
// //               onPressed: () async {
// //                 const filePath = "file:/C:/Users/ASUS/Documents";
// //                 await _launchUrl(filePath);
// //               },
// //               child: const CustomWidget(
// //                 icon: Icons.folder_open,
// //                 label: 'Open File/Folder',
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // /// Just a placeholder for your custom UI
// // class CustomWidget extends StatelessWidget {
// //   final IconData icon;
// //   final String label;
// //   const CustomWidget({super.key, required this.icon, required this.label});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(icon),
// //         const SizedBox(width: 8),
// //         Text(label, textAlign: TextAlign.center),
// //       ],
// //     );
// //   }
// // }
