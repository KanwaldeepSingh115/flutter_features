import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> requestCameraPermission() async {
  var status = await Permission.camera.status;
  if (status.isDenied) {
    status = await Permission.camera.request();
    if (status.isGranted) {
      print("Camera permission granted.");
    } else if (status.isPermanentlyDenied) {
      print("Camera permission permanently denied. Open app settings.");

      openAppSettings();
    } else {
      print("Camera permission denied.");
    }
  } else if (status.isGranted) {
    print("Camera permission already granted.");
  }
}

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  final MobileScannerController controller = MobileScannerController();
  final Set<String> scannedCodes = {};

  Future<void> handleBarcode(String code) async {
    final uri = Uri.parse(code);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not launch URL")));
    }
  }

  // Future<void> _handleBarcode(String code) async {
  //   // Check if scanned text is a URL
  //   final uri = Uri.tryParse(code);

  //   if (uri != null && (uri.isScheme("http") || uri.isScheme("https"))) {
  //     // Try launching the URL
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Could not open URL")),
  //       );
  //     }
  //   } else {
  //     // Just show the scanned text
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Scanned: $code")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Code Scaneer'),
        actions: [
          IconButton(
            onPressed: () => controller.toggleTorch(),
            icon: Icon(Icons.flash_on),
          ),
          IconButton(
            onPressed: () => controller.switchCamera(),
            icon: Icon(Icons.cameraswitch),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (barcodeCapture) {
          final code = barcodeCapture.barcodes.first.rawValue;
          if (code != null && !scannedCodes.contains(code)) {
            scannedCodes.add(code);
            handleBarcode(code);
          }
        },
      ),
    );
  }
}
