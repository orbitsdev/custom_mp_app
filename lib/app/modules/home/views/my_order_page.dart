import 'package:flutter/material.dart';

class MyOrderPage extends StatelessWidget {
const MyOrderPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: Container(child: Center(child: Text('My Order'))),
    );
  }
}