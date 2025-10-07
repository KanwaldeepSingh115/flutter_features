import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

class ScanResultWidget extends StatelessWidget {
  final Code? result;
  final VoidCallback onScanAgain;

  const ScanResultWidget({
    super.key,
    required this.result,
    required this.onScanAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scanned Code:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                result?.text ?? 'Unknown',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onScanAgain,
                child: const Text('Scan Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_zxing/flutter_zxing.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ScanResultWidget extends StatefulWidget {
//   final Code? result;
//   final VoidCallback onScanAgain;
//   const ScanResultWidget({
//     super.key,
//     required this.result,
//     required this.onScanAgain,
//   });

//   @override
//   State<ScanResultWidget> createState() => _ScanResultWidgetState();
// }

// class _ScanResultWidgetState extends State<ScanResultWidget> {
//   // Future<void> _launchURL(String url) async {
//   //   final uri = Uri.parse(url); // your URL is already valid
//   //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("Could not launch URL")));
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         margin: const EdgeInsets.all(20),
//         elevation: 5,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Scanned Code:',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () async {
//                   final scannedText = widget.result?.text;
//                   if (scannedText != null && scannedText.isNotEmpty) {
//                     final uri = Uri.parse(scannedText);
//                     if (!await launchUrl(
//                       uri,
//                       mode: LaunchMode.externalApplication,
//                     )) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Could not launch URL")),
//                       );
//                     }
//                   }
//                 },
//                 child: Text(
//                   widget.result?.text ?? 'Unknown',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),

//               // Text(
//               //   widget.result?.text ?? 'Unknown',
//               //   style: const TextStyle(fontSize: 18),
//               //   textAlign: TextAlign.center,
//               // ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       final scannedText = widget.result?.text;
//                       if (scannedText != null && scannedText.isNotEmpty) {
//                         final uri = Uri.parse(scannedText);
//                         if (!await launchUrl(
//                           uri,
//                           mode: LaunchMode.externalApplication,
//                         )) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text("Could not launch URL"),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                     child: Text('Launch URL'),
//                   ),

//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: widget.onScanAgain,
//                     child: const Text('Scan Again'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// // import 'package:flutter/material.dart';
// // import 'package:flutter_zxing/flutter_zxing.dart';

// // class ScanResultWidget extends StatelessWidget {
//   // final Code? result;
//   // final VoidCallback onScanAgain;

// //   const ScanResultWidget({
// //     super.key,
//     // required this.result,
//     // required this.onScanAgain,
// //   });

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Center(
//   //     child: Card(
//   //       margin: const EdgeInsets.all(20),
//   //       elevation: 5,
//   //       child: Padding(
//   //         padding: const EdgeInsets.all(16),
//   //         child: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             Text(
//   //               'Scanned Code:',
//   //               style: Theme.of(context).textTheme.titleLarge,
//   //             ),
//   //             const SizedBox(height: 10),
//   //             Text(
//   //               result?.text ?? 'Unknown',
//   //               style: const TextStyle(fontSize: 18),
//   //               textAlign: TextAlign.center,
//   //             ),
//   //             const SizedBox(height: 20),
//   //             ElevatedButton(
//   //               onPressed: onScanAgain,
//   //               child: const Text('Scan Again'),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// // }
