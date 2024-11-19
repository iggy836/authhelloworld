import 'package:flutter/material.dart';

// home_screen.dart の内容
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画面B'),
      ),
      body: const Center(
        child: Text('画面Bです。'),
      ),
    );
  }
}