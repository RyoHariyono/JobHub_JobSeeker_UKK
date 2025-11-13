import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_jobseeker_ukk/data/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Delay untuk splash screen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check auth status
    if (_authService.isLoggedIn) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau Icon
              Icon(Icons.work_rounded, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'JobHub',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find Your Dream Job',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
