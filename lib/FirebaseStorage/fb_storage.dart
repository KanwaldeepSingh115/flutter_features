import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseStorageExample extends StatefulWidget {
  const FirebaseStorageExample({super.key});

  @override
  State<FirebaseStorageExample> createState() =>
      _FirebaseStorageExampleState();
}

class _FirebaseStorageExampleState extends State<FirebaseStorageExample> {
  File? _imageFile;
  String? _downloadUrl;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Platform not supported")));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      
      final url = await _uploadFile(_imageFile!);
      setState(() {
        _downloadUrl = url;
      });
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
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Storage Example")),
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
                ? Text("Download URL:\n$_downloadUrl")
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
