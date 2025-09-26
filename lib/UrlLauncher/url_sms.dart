import 'package:flutter/material.dart';
import 'package:flutter_practice/UrlLauncher/url_call.dart';
import 'package:url_launcher/url_launcher.dart';

class SmsLauncherPage extends StatefulWidget {
  @override
  _SmsLauncherPageState createState() => _SmsLauncherPageState();
}

class _SmsLauncherPageState extends State<SmsLauncherPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  /// Open the default messaging app with phone & message
  Future<void> sendSMS(String phone, String message) async {
    // Encode message to handle special characters
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open URL app')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send URL with URl launcher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    sendSMS(
                      _phoneController.text.trim(),
                      _messageController.text.trim(),
                    );
                  },
                  child: Text("Send URL"),
                ),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallWidget(phoneNumber: _phoneController.text,)),
                  );
                }, child: Text("Call"))
              ],
            )

          ],
        ),
      ),
    );
  }
}
