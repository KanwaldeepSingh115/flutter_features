import 'dart:typed_data';
import 'package:flutter/material.dart';

class DebugInfoWidget extends StatelessWidget {
  final int successScans;
  final int failedScans;
  final String? error;
  final int duration;
  final VoidCallback onReset;
  final Uint8List? imageBytes;

  const DebugInfoWidget({
    super.key,
    required this.successScans,
    required this.failedScans,
    this.error,
    required this.duration,
    required this.onReset,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Debug Info', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Text('Success Scans: $successScans'),
            Text('Failed Scans: $failedScans'),
            Text('Duration: ${duration}ms'),
            if (error != null && error!.isNotEmpty)
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            if (imageBytes != null)
              SizedBox(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(imageBytes!, fit: BoxFit.contain),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
