//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/fcm/fcm_send.dart';

class FcmSendUi extends StatefulWidget {
  const FcmSendUi({super.key});

  @override
  State<FcmSendUi> createState() => _FcmSendUiState();
}

class _FcmSendUiState extends State<FcmSendUi> {
  var fcmToken =
      "cJCu2sy0TPChZWxVbKJb2f:APA91bH02qm4XSLPs3PDOyW-RDMqmcEKkZbFKz5k4wjNdEXij_XTFhrC2Kok6lfkPtrbBPRslBwHMb869qMIz6VOcxFf5xlQ5SWieQQSldDHBGDslYP_X3E";
  //"ep3UyxoZRJOtw9qlBGLkcN:APA91bFCaLWVJ1_rsWSpKbUMkdE5ZzRtKQdWlM_VYpFPZJvQizTAqlAKVc9JyAJ6jKvNQ7Z9WdrfsWiRen4eUL20lSC0pdADVbLzP0MbqLahiRdQvBICmdY";

  // void _getDeviceToken() async {
  //   String? fcmToken = await FirebaseMessaging.instance.getToken();
  //   print("FCM Token: $fcmToken");
  // }

  @override
  void initState() {
    super.initState();
    print(FCMSend().getAccessTokens());
    //_getDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 350),
          Center(
            child: ElevatedButton(
              onPressed: () {
                FCMSend().sendPushNotification(
                  fcmToken: fcmToken,
                  title: 'hello',
                  body: 'this is the message body',
                );
              },
              child: Text('Send Notification'),
            ),
          ),
        ],
      ),
    );
  }
}
