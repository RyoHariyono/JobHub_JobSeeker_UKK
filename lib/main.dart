import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/routing/app_router.dart';

void main() {
  runApp(const JobHubApp());
}

class JobHubApp extends StatelessWidget {
  const JobHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
