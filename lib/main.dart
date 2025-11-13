import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/routing/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ejijsjnswpsdtgapzade.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqaWpzam5zd3BzZHRnYXB6YWRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI5ODQ5MjMsImV4cCI6MjA3ODU2MDkyM30.clTEVnjN61a2Qugd8Bi0i5WHgaCYdhYLvBQ90AVfMl0',
  );

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
