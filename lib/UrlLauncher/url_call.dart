import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallWidget extends StatelessWidget {
  final String phoneNumber;

  const CallWidget({super.key, required this.phoneNumber});

  
  Future<void> _makeCall(BuildContext context) async {
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number is empty")),
      );
      return;
    }

    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not initiate call")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _makeCall(context),
        icon: Icon(Icons.call),
        label: Text("Call $phoneNumber"),

      ),
    );
  }
}
