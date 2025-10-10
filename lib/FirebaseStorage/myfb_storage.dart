import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyFirebaseStorage extends StatefulWidget {
  const MyFirebaseStorage({super.key});

  @override
  State<MyFirebaseStorage> createState() => _MyFirebaseStorageState();
}

class _MyFirebaseStorageState extends State<MyFirebaseStorage> {
  File? _imageFile;
  String? _downloadUrl;
  bool _isDownloading = false;

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) return true;
      var status = await Permission.photos.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      return true;
    } else {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Platform not supported")));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      final url = await _uploadFile(_imageFile!);
      if (url != null) {
        setState(() {
          _downloadUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully!")),
        );
      }
    }
  }

  Future<String?> _uploadFile(File image) async {
    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: ${e.message}')));
      return null;
    }
  }

  Future<void> _downloadAndSaveFile() async {
    if (_downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No uploaded image to download!")),
      );
      return;
    }

    setState(() => _isDownloading = true);

    try {
      bool granted = await _requestStoragePermission();
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
        setState(() => _isDownloading = false);
        return;
      }

      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory("/storage/emulated/0/Download");
      } else {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      final filePath =
          "${downloadsDir.path}/firebase_image_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final response = await http.get(Uri.parse(_downloadUrl!));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved to Downloads: $filePath")),
      );
    } catch (e) {
      print("Error saving file: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save image")));
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Storage Example")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isDownloading ? null : _downloadAndSaveFile,
        icon: const Icon(Icons.download),
        label: Text(_isDownloading ? "Saving..." : "Download"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const Text("No image selected"),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _pickImage,
              child: const Text("Pick & Upload Image"),
            ),
            const SizedBox(height: 20),
            _downloadUrl != null
                ? SelectableText("Download URL:\n$_downloadUrl")
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
