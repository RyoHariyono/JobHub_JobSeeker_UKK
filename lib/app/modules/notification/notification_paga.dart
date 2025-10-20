import 'package:flutter/material.dart';

class NotificationPaga extends StatelessWidget {
  const NotificationPaga({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Page')),
      body: const Center(child: Text('Welcome to the Notification Page!')),
    );
  }
}
