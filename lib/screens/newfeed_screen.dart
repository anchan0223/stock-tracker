import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Screen'),
      ),
      body: const Center(
        child: Text('This is the News screen!'),
      ),
    );
  }
}
