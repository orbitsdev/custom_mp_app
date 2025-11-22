import 'package:flutter/material.dart';

class PaymentWebviewPage extends StatefulWidget {
  const PaymentWebviewPage({ Key? key }) : super(key: key);

  @override
  _PaymentWebviewPageState createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: Container(),
    );
  }
}