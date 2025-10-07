import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MyCameraScreen({super.key, required this.cameras});

  @override
  State<MyCameraScreen> createState() => _MyCameraScreenState();
}

class _MyCameraScreenState extends State<MyCameraScreen> {
  CameraController? _controller;
  final List<XFile> _capturedImages = [];
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _hasPermission = true);
      _initCamera();
    } else {
      setState(() => _hasPermission = false);
    }
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();
    setState(() {
      _capturedImages.add(image);
    });
  }

  void _openGallery(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        if (_capturedImages.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No images captured yet.")),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _capturedImages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => FullImageScreen(
                          imageFile: File(_capturedImages[index].path),
                        ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_capturedImages[index].path),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return const Scaffold(
        body: Center(child: Text("Camera permission not granted")),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera Example")),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: CameraPreview(_controller!)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _takePicture,
                child: const Text("Take Picture"),
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _openGallery(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image:
                      _capturedImages.isNotEmpty
                          ? DecorationImage(
                            image: FileImage(File(_capturedImages.last.path)),
                            fit: BoxFit.cover,
                          )
                          : null,
                  color: Colors.blueAccent,
                ),
                child:
                    _capturedImages.isEmpty
                        ? const Icon(Icons.photo_library, color: Colors.white)
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final File imageFile;

  const FullImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.file(imageFile)),
    );
  }
}
