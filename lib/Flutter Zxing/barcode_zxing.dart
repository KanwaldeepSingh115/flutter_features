import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:ui_practice/BarCodeScanner_Generator_Zxing/result.dart';
import 'package:ui_practice/BarCodeScanner_Generator_Zxing/debug_info.dart';

class ZxingPage extends StatefulWidget {
  const ZxingPage({super.key});

  @override
  State<ZxingPage> createState() => _ZxingPageState();
}

class _ZxingPageState extends State<ZxingPage> {
  Uint8List? createdCodeBytes;

  Code? result;
  Codes? multiResult;

  bool isMultiScan = false;
  bool showDebugInfo = true;
  bool hasPermission = false;

  int successScans = 0;
  int failedScans = 0;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    setState(() {
      hasPermission = status.isGranted;
    });
    if (!hasPermission && status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCameraSupported =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'Scan Code'),
              Tab(text: 'Create Code'),
              Tab(text: 'Scan Info'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (kIsWeb)
              const Center(child: Text('Unsupported platform for scanning'))
            else if (!isCameraSupported)
              const Center(child: Text('Camera not supported on this platform'))
            else if (!hasPermission)
              Center(
                child: ElevatedButton(
                  onPressed: _checkCameraPermission,
                  child: const Text('Grant Camera Permission'),
                ),
              )
            else if (result != null && result?.isValid == true)
              ScanResultWidget(
                result: result,
                onScanAgain: () => setState(() => result = null),
              )
            else
              Stack(
                children: [
                  ReaderWidget(
                    onScan: _onScanSuccess,
                    onScanFailure: _onScanFailure,
                    onMultiScan: _onMultiScanSuccess,
                    onMultiScanFailure: _onMultiScanFailure,
                    onMultiScanModeChanged: _onMultiScanModeChanged,
                    onControllerCreated: _onControllerCreated,
                    isMultiScan: isMultiScan,
                    cropPercent: 0.5,
                    verticalCropOffset: 0,
                    horizontalCropOffset: 0,
                    tryInverted: true,
                    tryDownscale: true,
                    maxNumberOfSymbols: 5,
                    scanDelay: Duration(milliseconds: isMultiScan ? 50 : 500),
                    resolution: ResolutionPreset.high,
                    lensDirection: CameraLensDirection.back,
                    flashOnIcon: const Icon(Icons.flash_on),
                    flashOffIcon: const Icon(Icons.flash_off),
                    flashAlwaysIcon: const Icon(Icons.flash_on),
                    flashAutoIcon: const Icon(Icons.flash_auto),
                    galleryIcon: const Icon(Icons.photo_library),
                    toggleCameraIcon: const Icon(Icons.switch_camera),
                    actionButtonsBackgroundBorderRadius: BorderRadius.circular(
                      10,
                    ),
                    actionButtonsBackgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  // if (showDebugInfo)
                  //   DebugInfoWidget(
                  //     successScans: successScans,
                  //     failedScans: failedScans,
                  //     error: isMultiScan ? multiResult?.error : result?.error,
                  //     duration:
                  //         isMultiScan
                  //             ? multiResult?.duration ?? 0
                  //             : result?.duration ?? 0,
                  //     onReset: _onReset,
                  //     imageBytes:
                  //         !isMultiScan && result?.imageBytes != null
                  //             ? pngFromBytes(
                  //               result?.imageBytes ?? Uint8List(0),
                  //               result?.imageWidth ?? 0,
                  //               result?.imageHeight ?? 0,
                  //             )
                  //             : null,
                  //   ),
                ],
              ),
            SingleChildScrollView(
              child: Column(
                children: [
                  WriterWidget(
                    messages: const Messages(createButton: 'Create Code'),
                    onSuccess: (result, bytes) {
                      setState(() {
                        createdCodeBytes = bytes;
                      });
                    },
                    onError: (error) {
                      _showMessage(context, 'Error: $error');
                    },
                  ),
                  if (createdCodeBytes != null)
                    Image.memory(createdCodeBytes ?? Uint8List(0)),
                ],
              ),
            ),

            Column(
              children: [
                DebugInfoWidget(
                  successScans: successScans,
                  failedScans: failedScans,
                  error: isMultiScan ? multiResult?.error : result?.error,
                  duration:
                      isMultiScan
                          ? multiResult?.duration ?? 0
                          : result?.duration ?? 0,
                  onReset: _onReset,
                  imageBytes:
                      !isMultiScan && result?.imageBytes != null
                          ? pngFromBytes(
                            result?.imageBytes ?? Uint8List(0),
                            result?.imageWidth ?? 0,
                            result?.imageHeight ?? 0,
                          )
                          : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onControllerCreated(CameraController? controller, Exception? error) {
    if (error != null) {
      _showMessage(context, 'Error: $error');
    }
  }

  void _onScanSuccess(Code? code) {
    setState(() {
      successScans++;
      result = code;
    });
  }

  void _onScanFailure(Code? code) {
    setState(() {
      failedScans++;
      result = code;
    });
    if (code?.error?.isNotEmpty == true) {
      _showMessage(context, 'Error: ${code?.error}');
    }
  }

  void _onMultiScanSuccess(Codes codes) {
    setState(() {
      successScans++;
      multiResult = codes;
    });
  }

  void _onMultiScanFailure(Codes result) {
    setState(() {
      failedScans++;
      multiResult = result;
    });
    if (result.codes.isNotEmpty == true) {
      _showMessage(context, 'Error: ${result.codes.first.error}');
    }
  }

  void _onMultiScanModeChanged(bool isMultiScan) {
    setState(() {
      this.isMultiScan = isMultiScan;
    });
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onReset() {
    setState(() {
      successScans = 0;
      failedScans = 0;
    });
  }
}
