import 'package:flutter/material.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stocks Screen'),
      ),
      body: const Center(
        child: Text('This is the Stocks screen!'),
      ),
    );
  }
}
