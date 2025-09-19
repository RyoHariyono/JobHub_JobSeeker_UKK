import 'package:flutter/material.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Application Page')),
      body: const Center(child: Text('Welcome to the Application Page!')),
    );
  }
}
