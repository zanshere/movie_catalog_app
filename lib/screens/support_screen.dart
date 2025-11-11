import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Need help? You can contact support at support@movieapp.com\n\nFAQ and troubleshooting will be available here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
