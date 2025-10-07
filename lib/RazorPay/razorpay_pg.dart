import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPgScreen extends StatefulWidget {
  const RazorpayPgScreen({super.key});

  @override
  State<RazorpayPgScreen> createState() => _RazorpayPgScreenState();
}

class _RazorpayPgScreenState extends State<RazorpayPgScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Gateway')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pay with Razorpay'),
            ElevatedButton(
              onPressed: () {
                Razorpay razorpay = Razorpay();
                var options = {
                  'key': 'YOUR_API_KEY_HERE',
                  'amount': 100,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com',
                  },
                  'external': {
                    'wallets': ['paytm'],
                  },
                };
                razorpay.on(
                  Razorpay.EVENT_PAYMENT_ERROR,
                  handlePaymentErrorResponse,
                );
                razorpay.on(
                  Razorpay.EVENT_PAYMENT_SUCCESS,
                  handlePaymentSuccessResponse,
                );
                razorpay.on(
                  Razorpay.EVENT_EXTERNAL_WALLET,
                  handleExternalWalletSelected,
                );
                razorpay.open(options);
              },
              child: Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(
      context,
      "Payment Failed",
      "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}",
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(
      context,
      "Payment Successful",
      "Payment ID: ${response.paymentId}",
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      "External Wallet Selected",
      "${response.walletName}",
    );
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      onPressed: () {},
      child: Text('Continue'),
    );
    AlertDialog alert = AlertDialog(title: Text(title), content: Text(message));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
