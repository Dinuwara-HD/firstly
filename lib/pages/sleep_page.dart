import 'package:flutter/material.dart';

class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          'Sleep content goes here!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
