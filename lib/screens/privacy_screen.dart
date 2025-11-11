import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Here you can manage your privacy preferences, permissions, and data settings.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
