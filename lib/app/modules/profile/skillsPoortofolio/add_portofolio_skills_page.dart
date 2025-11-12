import 'package:flutter/material.dart';

class AddPortofolioSkillsPage extends StatefulWidget {
  const AddPortofolioSkillsPage({super.key});

  @override
  State<AddPortofolioSkillsPage> createState() =>
      _AddPortofolioSkillsPageState();
}

class _AddPortofolioSkillsPageState extends State<AddPortofolioSkillsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Portofolio & Skills')),
      body: Center(child: Text('Add Portofolio & Skills Page Content Here')),
    );
  }
}
