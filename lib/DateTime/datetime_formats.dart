import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class DateTimeFormatter extends StatelessWidget {
  const DateTimeFormatter({super.key});

  Stream<DateTime> _timeStream() =>
      Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());

  Widget _buildCard(String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream(),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final now = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Date & Time'),
            backgroundColor: Colors.blueAccent,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildCard("Default", "$now"),
                _buildCard("Date only", DateFormat('yyyy-MM-dd').format(now)),
                _buildCard(
                  "Time (24-hour)",
                  DateFormat('HH:mm:ss').format(now),
                ),
                _buildCard(
                  "Time (12-hour)",
                  DateFormat('hh:mm:ss a').format(now),
                ),
                _buildCard("Day name", DateFormat('EEEE').format(now)),
                _buildCard("Month name", DateFormat('MMMM').format(now)),
                _buildCard("Short date", DateFormat.yMd().format(now)),
                _buildCard("Long date", DateFormat.yMMMMEEEEd().format(now)),
                _buildCard(
                  "Milliseconds since epoch",
                  "${now.millisecondsSinceEpoch}",
                ),
                _buildCard("ISO8601", now.toIso8601String()),
                _buildCard(
                  "Custom (dd/MM/yyyy HH:mm)",
                  DateFormat('dd/MM/yyyy HH:mm').format(now),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
